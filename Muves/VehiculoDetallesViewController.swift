//
//  VehiculoDetallesViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 15/12/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Foundation
import Contacts

class VehiculoDetallesViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var numeroUsuarioLabel: UILabel!
    @IBOutlet weak var vehiculoUsuarioLabel: UILabel!
    @IBOutlet weak var tareaUsuarioLabel: UILabel!
    @IBOutlet weak var frecuenciaRutaLabel: UILabel!
    @IBOutlet weak var tiempoRecorridoLabel: UILabel!
    @IBOutlet weak var velocidadPromedioLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var pointLocation:CLLocationCoordinate2D!
    @IBOutlet weak var detallesView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.window?.isUserInteractionEnabled = true
        self.navigationController?.view.window?.isUserInteractionEnabled = true
        self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        self.popoverPresentationController?.sourceRect = CGRect(x: 229, y: 200, width: 0, height: 0)
        
        //Hacer redondas las esquinas de los elementos
        detallesView.layer.cornerRadius = 5.0
        mapView.layer.cornerRadius = 5.0
        
        // Obtener localizacón del usuario
        self.locationManager =  CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.delegate = self
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
            self.mapView.setRegion(region, animated: true)
        }
        self.mapView.showsUserLocation = true
        self.mapView.mapType = MKMapType.standard
        
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
    }
    
    @IBAction func cerrar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        
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
        mapView.add(myPolyline)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
