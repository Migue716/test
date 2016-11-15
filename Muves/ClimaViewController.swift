//
//  ViewController2.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 12/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit
import CoreLocation

class ClimaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var principalView: UIView!
    @IBOutlet weak var UVbackgroundView: UIView!
    @IBOutlet weak var UVvalueLabel: UILabel!
    @IBOutlet weak var climaView: UIView!
    @IBOutlet weak var horasCollectionView: UICollectionView!
    @IBOutlet weak var diasCollectionView: UICollectionView!
    @IBOutlet weak var tempActualLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tiempoImage: UIImageView!
    @IBOutlet weak var ciudadLabel: UILabel!
    var locationManager: CLLocationManager!
    let horas : [String] = ["12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM"]
    let horas_iconos : [String] = ["lluvia_sol", "lluvia_sol", "lluvia_sol", "lluvia_sol", "lluvia_sol", "lluvia_sol"]
    let horas_temp : [String] = ["29º", "29º", "30º", "29º", "31º", "29º"]
    var dias : [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-"]
    var dias_iconos : [String] = ["1", "1", "1", "1", "1", "1", "1", "1", "1"]
    var dias_temp : [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-"]
    var jsonData : JSON!
    var latitud : Double!
    var longitud : Double!
    var ciudad : String!
    var pais : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Colocar la vista de Menu en frente
        self.view.bringSubview(toFront: menuView)
        
        //Programar gesto para que se abra el Menu si tocas una parte limpia de la barra
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.abrirMenuButton(_:)))
        self.menuView.addGestureRecognizer(gesture)
        
        // Obtener localizacón del usuario
        self.locationManager =  CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()

        if (self.locationManager.location != nil){
            let location = self.locationManager.location
            self.latitud = location!.coordinate.latitude
            self.longitud = location!.coordinate.longitude
            
            print("Latitud actual :: \(latitud!)")
            print("Longitud actual :: \(longitud!)")

        }
        principalView.layer.cornerRadius = 5.0
        
        // Petición GET al servidor
        let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22(\(latitud!),\(longitud!))%22)%20and%20u%3D%22c%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        //let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            //let task = URLSession.shared().dataTask(with: request) {data, response, err in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            
            do {
                self.jsonData = JSON(data: data!, options: [], error: nil)
                print("Ciudad=\(self.jsonData ["query"]["results"]["channel"]["location"]["city"])")
                print("Temp Actual=\(self.jsonData ["query"]["results"]["channel"]["item"]["condition"]["temp"])")
                print("Temp Icono ID=\(self.jsonData ["query"]["results"]["channel"]["item"]["forecast"][0]["code"])")
                print("Temp Max=\(self.jsonData ["query"]["results"]["channel"]["item"]["forecast"][0]["high"])")
                print("Temp Min=\(self.jsonData ["query"]["results"]["channel"]["item"]["forecast"][0]["low"])")
                self.ciudad = self.jsonData["query"]["results"]["channel"]["location"]["city"].stringValue
                self.pais = self.jsonData["query"]["results"]["channel"]["location"]["country"].stringValue
                print("Ciudad=\(self.jsonData ["query"]["results"]["channel"]["location"]["city"])")
                print("Pais=\(self.jsonData ["query"]["results"]["channel"]["location"]["country"])")
                DispatchQueue.main.async {
                    self.tempActualLabel.text = "\(self.jsonData["query"]["results"]["channel"]["item"]["condition"]["temp"])ºC"
                    self.tempMaxLabel.text = "\(self.jsonData["query"]["results"]["channel"]["item"]["forecast"][0]["high"])ºC"
                    self.tempMinLabel.text = "\(self.jsonData["query"]["results"]["channel"]["item"]["forecast"][0]["low"])ºC"
                    self.ciudadLabel.text = "\(self.ciudad!), \(self.pais!)"
                    for var i in (0..<self.dias.count){
                        self.dias[i] = self.jsonData["query"]["results"]["channel"]["item"]["forecast"][i+1]["day"].stringValue
                        self.dias_iconos[i] = self.jsonData["query"]["results"]["channel"]["item"]["forecast"][i+1]["code"].stringValue
                        self.dias_temp[i] = "\(self.jsonData["query"]["results"]["channel"]["item"]["forecast"][i+1]["high"])ºC"
                    }
                    self.diasCollectionView.reloadData()
                }
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    //print("success == \(responseDictionary)")
                    
                    // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                    //
                    DispatchQueue.main.async {
                        print("Recargo datos")
                    }
                    
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
            }
        }
        task.resume()

    }
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.horasCollectionView {
            return horas.count
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.horasCollectionView {
            let Cell: HorasYahooCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "horasCV", for: indexPath as IndexPath) as! HorasYahooCollectionViewCell
            Cell.hora.text = horas[indexPath.row]
            Cell.icono.image = UIImage(named: horas_iconos[indexPath.row])
            Cell.temperatura.text = horas_temp[indexPath.row]
            return Cell
        } else {
            let Cell: DiasYahooCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "diasCV", for: indexPath as IndexPath) as! DiasYahooCollectionViewCell
            Cell.dia.text = dias[indexPath.row]
            Cell.icono.image = UIImage(named: "lluvia_sol")
            Cell.temperatura.text = dias_temp[indexPath.row]
            return Cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.horasCollectionView {
            print("HorasCV con # \(indexPath.row)")
        } else {
            print("DiasCV con # \(indexPath.row)")
        }
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
