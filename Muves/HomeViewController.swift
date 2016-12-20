//
//  TareasViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 24/11/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Foundation
import Contacts
//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
//
// MARK: - View Controller
//
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    var sections = [Section]()
    var locationManager: CLLocationManager!
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Programar gesto para que se abra el Menu si tocas una parte limpia de la barra
        //let gesture = UITapGestureRecognizer(target: self, action: #selector (self.abrirMenuButton(_:)))
        //self.menuView.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view.
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        //Colocar la vista de Menu en frente
        self.view.bringSubview(toFront: menuView)
        
        self.menuTableView.separatorStyle = .none
        sections = [
            Section(name: "Inicio", items: []),
            Section(name: "Información del vehículo", items: []),
            Section(name: "Hábitos de manejo", items: ["uno", "dos", "tres", "cuatro"]),
            Section(name: "Tareas", items: ["Usuario 1", "Usuario 2", "Usuario 3"]),  Section(name: "Dispositivo", items: []), Section(name: "Usuario", items: []), Section(name: "Reportes", items: []),
        ]
        //sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        sections[1].items.append("antier")
        sections[1].items.append("ayer")
        sections[1].items.append("hoy")
        
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
        
        // Add annotation:
        let annotation = CustomPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude:  19.2485448019758, longitude:  -103.667705906652)
        annotation.title = "Puntero"
        annotation.subtitle = ""
        annotation.imageName = "locacion"
        //let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
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
            menuTableView.isHidden = false
            flechaUIButton.setBackgroundImage(UIImage(named: "flecha_izq"), for: UIControlState.normal)
        } else {
            //View will slide 150px up
            let xPosicion = menuView.frame.origin.x - 150
            
            let height = menuView.frame.size.height
            let width = menuView.frame.size.width
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.menuView.frame = CGRect(x: xPosicion, y: yPosicion, width: width, height: height)
                
            })
            menuTableView.isHidden = true
            flechaUIButton.setBackgroundImage(UIImage(named: "flecha_der"), for: UIControlState.normal)
        }
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? CustomPointAnnotation {
            self.performSegue(withIdentifier: "detalleSegue", sender: self)
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection)  -> UIModalPresentationStyle {
        return .none
    }
    func TapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        //gestureRecognizer.view?.tag = 1
        print("Presiono el header de la seccion \(gestureRecognizer.view!.tag)")
        if gestureRecognizer.view!.tag == 5 {
            self.performSegue(withIdentifier: "perfilSegue", sender: self)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "usuarioSegue" {

        }
        if segue.identifier == "detalleSegue" {
            let reportarViewController = segue.destination as! VehiculoDetallesViewController
            reportarViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            reportarViewController.popoverPresentationController!.delegate = self
        }
    }
}

//
// MARK: - View Controller DataSource and Delegate
//
extension HomeViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        cell.textLabel?.font = UIFont(name:"Chivo-Regular", size: 14.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].collapsed! ? 0 : 54.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seleccionaste la fila #\(indexPath.row)! y header: \(indexPath.section)")
        self.performSegue(withIdentifier: "tareasSegue", sender: self)
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = "+"
        header.setCollapsed(sections[section].collapsed)
        header.titleLabel.numberOfLines = 0
        header.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        header.section = section
        header.delegate = self
        
        if header.section == 0 || header.section == 4 || header.section == 5 || header.section == 6 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.TapGestureRecognizer(gestureRecognizer:)))
            tapGesture.numberOfTouchesRequired = 1;
            tapGesture.numberOfTapsRequired = 1;
            header.tag = header.section
            header.addGestureRecognizer(tapGesture)
        }
        // Si utilizamos el siguiente codigo no se expanden las filas
        /*
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.TapGestureRecognizer(gestureRecognizer:)))
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.numberOfTapsRequired = 1;
        header.addGestureRecognizer(tapGesture)
        */
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

//
// MARK: - Section Header Delegate
//
extension HomeViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
 
        // Adjust the height of the rows inside the section
        
        menuTableView.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            menuTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        menuTableView.endUpdates()
    }
    
}
