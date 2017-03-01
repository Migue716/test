//
//  ViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 12/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Foundation
import Contacts

class MapaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,UIGestureRecognizerDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    var locationManager: CLLocationManager!
    var pointLocation:CLLocationCoordinate2D!
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var reportarButton: UIButton!
    
    //variables para busqueda en mapa
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var directionDictionary: [String:String] = [
    "calle" : "",
    "numero" : "",
    "ciudad" :"",
    "estado" : ""
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //Colocar la vista de Menu en frente
        self.view.bringSubview(toFront: menuView)
        
        //Programar gesto para que se abra el Menu si tocas una parte limpia de la barra
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.abrirMenuButton(_:)))
        self.menuView.addGestureRecognizer(gesture)
        
        //Hacer redondas las esquinas del boton Reportar
        reportarButton.layer.cornerRadius = 5.0
        
        // Obtener localizacón del usuario
        self.locationManager =  CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.MapView.delegate = self
        if (self.locationManager.location != nil){
            let location = self.locationManager.location
            let latitude: Double = location!.coordinate.latitude
            let longitude: Double = location!.coordinate.longitude
            
            print("Latitud actual :: \(latitude)")
            print("Longitud actual :: \(longitude)")
            
            let latDelta:CLLocationDegrees = 0.04
            let longDelta:CLLocationDegrees = 0.04
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake((self.locationManager.location?.coordinate)!, theSpan)
            self.MapView.setRegion(region, animated: true)
        }
        self.MapView.showsUserLocation = true
        self.MapView.mapType = MKMapType.standard
        
        //Colocar pin en una ubicacion
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        MapView.addGestureRecognizer(gestureRecognizer)
        
        /*
        //agregar ruta
        let track = Track()
        track.latitude.append("19.2647424")
        track.longitude.append("-103.7157062")
        track.latitude.append("19.2649215")
        track.longitude.append("-103.7160807")
        track.latitude.append("19.2664483")
        track.longitude.append("-103.7155511")
        track.latitude.append("19.2673705")
        track.longitude.append("-103.7172173")
        track.latitude.append("19.2741941")
        track.longitude.append("-103.71506")
        addRoute(track: track)
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.MapView.setRegion(region, animated: true)
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            let customPoint = annotation as! CustomPointAnnotation
            
            // Rezise image
            let pinImage = UIImage(named: customPoint.imageName)
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Set Pin Image
            annotationView.image = resizedImage
        }
        
        return annotationView
        
    }
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let allAnnotations = self.MapView.annotations
        self.MapView.removeAnnotations(allAnnotations)
        
        let location = gestureReconizer.location(in: MapView)
        print("Ubicación del PIN: \(location)")
        let coordinate = MapView.convert(location,toCoordinateFrom: MapView)
        
        // Add annotation:
        let annotation = CustomPointAnnotation()
        annotation.title = "Puntero"
        annotation.subtitle = ""
        annotation.imageName = "locacion"
        //let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        MapView.addAnnotation(annotation)
        getDirections(coordinate: annotation.coordinate)
        
    }
    func getDirections(coordinate : CLLocationCoordinate2D) {
        //Obtener datos del puntero
        let geoCoder = CLGeocoder()
        let locationGeo = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(locationGeo, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary)
         
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                //print(street)
                self.directionDictionary["calle"] = street
            } else {
                self.directionDictionary["calle"] = ""
            }
            
            // House Number
            if let houseNumber = placeMark.addressDictionary!["SubThoroughfare"] as? String {
                //print(houseNumber)
                self.directionDictionary["numero"] = houseNumber
            } else {
                self.directionDictionary["numero"] = ""
            }
            
            // Estado
            if let state = placeMark.addressDictionary!["State"] as? String {
                //print(state)
                self.directionDictionary["estado"] = state
            } else {
                self.directionDictionary["estado"] = ""
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                //print(city)
                self.directionDictionary["ciudad"] = city
            } else {
                self.directionDictionary["ciudad"] = ""
            }
            print("directionDictionary: \(self.directionDictionary)")
            
        })

    }
    @IBAction func abrirMenuButton(_ sender: AnyObject) {
        
        let yPosicion = menuView.frame.origin.y
        
        if (menuView.frame.origin.x == -150) {
            //View will slide 150px up
            let xPosicion = menuView.frame.origin.x + 150
            
            let height = menuView.frame.size.height
            let width = menuView.frame.size.width
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.menuView.frame = CGRect(x: xPosicion, y: yPosicion, width: width, height: height)
                
            })
            flechaUIButton.setBackgroundImage(UIImage(named: "flecha_izq"), for: UIControlState.normal)
        } else {
            //View will slide 150px up
            let xPosicion = menuView.frame.origin.x - 150
            
            let height = menuView.frame.size.height
            let width = menuView.frame.size.width
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.menuView.frame = CGRect(x: xPosicion, y: yPosicion, width: width, height: height)
                
            })
            flechaUIButton.setBackgroundImage(UIImage(named: "flecha_der"), for: UIControlState.normal)
        }
    }
    @IBAction func reportarEvento(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "popoverSegue", sender: self)
    }
    @IBAction func buscarDireccion(_ sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.MapView.annotations.count != 0{
            annotation = self.MapView.annotations[0]
            self.MapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Lugar no encontrado", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = CustomPointAnnotation()
            self.pointAnnotation.imageName = "locacion"
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.MapView.centerCoordinate = self.pointAnnotation.coordinate
            self.MapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.getDirections(coordinate: self.pointAnnotation.coordinate)
        }
    }
    // Funcion para que el popover se visualice correctamente
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection)  -> UIModalPresentationStyle {
        return .none
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            let reportarViewController = segue.destination as! ReportarViewController
            reportarViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            reportarViewController.popoverPresentationController!.delegate = self
            reportarViewController.directionDictionary = directionDictionary
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.red
            lineView.lineWidth = 2
            
            return lineView
        }
        
        return MKOverlayRenderer()
    }
    
    
    func addRoute(track : Track) {
        if track.latitude.count == 0 {
            return
        }
        var pointsToUse: [CLLocationCoordinate2D] = []
        
        for i in 0...track.latitude.count-1 {
            let x = CLLocationDegrees((track.latitude[i] as NSString).doubleValue)
            let y = CLLocationDegrees((track.longitude[i] as NSString).doubleValue)
            pointsToUse += [CLLocationCoordinate2DMake(x, y)]
        }
        let myPolyline = MKGeodesicPolyline(coordinates: pointsToUse, count: track.latitude.count)
        MapView.add(myPolyline)
    }
 
}
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
class Track{
    var latitude : [String] = []
    var longitude : [String] = []
}

