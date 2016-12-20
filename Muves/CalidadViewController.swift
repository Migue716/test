//
//  ViewController3.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 12/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class CalidadViewController: UIViewController {
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var calidadLabel: UILabel!
    @IBOutlet weak var recomendacionesLabel: UILabel!
    @IBOutlet weak var O3Label: UILabel!
    @IBOutlet weak var O3valueLabel: UILabel!
    @IBOutlet weak var SO2Label: UILabel!
    @IBOutlet weak var SO2valueLabel: UILabel!
    @IBOutlet weak var NO2Label: UILabel!
    @IBOutlet weak var NO2valueLabel: UILabel!
    @IBOutlet weak var COLabel: UILabel!
    @IBOutlet weak var COvalueLabel: UILabel!
    @IBOutlet weak var PM10Label: UILabel!
    @IBOutlet weak var PM10valueLabel: UILabel!
    @IBOutlet weak var PM25Label: UILabel!
    @IBOutlet weak var PM25valueLabel: UILabel!
    @IBOutlet weak var calidadView: UIView!
    @IBOutlet weak var sustanciasView: UIView!
    @IBOutlet weak var calidadColorView: UIView!
    var jsonData : JSON!
    var fechaActual : String!
    var calidadGeneral = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        //Colocar la vista de Menu en frente
        self.view.bringSubview(toFront: menuView)
        
        //Programar gesto para que se abra el Menu si tocas una parte limpia de la barra
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.abrirMenuButton(_:)))
        self.menuView.addGestureRecognizer(gesture)
        
        calidadView.layer.cornerRadius = 5.0
        sustanciasView.layer.cornerRadius = 5.0
        calidadColorView.layer.cornerRadius = 5.0
        
        //Obtener fecha
        let date = Date()
        var dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm";
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        fechaActual = dateFormatter.string(from: date)
        
        //DATOS TEMPORALES
        self.comparacion(objeto: self.O3Label, valorLabel: self.O3valueLabel,valor: "453", color: 1)
        self.comparacion(objeto: self.SO2Label, valorLabel: self.SO2valueLabel,valor: "7467", color: 2)
        self.comparacion(objeto: self.NO2Label, valorLabel: self.NO2valueLabel,valor: "133", color: 3)
        self.comparacion(objeto: self.COLabel, valorLabel: self.COvalueLabel,valor: "1736", color: 4)
        self.comparacion(objeto: self.PM10Label, valorLabel: self.PM10valueLabel,valor: "585", color: 5)
        self.comparacion(objeto: self.PM25Label, valorLabel: self.PM25valueLabel,valor: "8298", color: 1)
        print("La calidad general es: \(self.calidadGeneral)")
        self.calidad(etiqueta: self.calidadLabel, view: self.calidadColorView, recomendacion: self.recomendacionesLabel, color: self.calidadGeneral)
        //TERMINA DATOS TEMPORALES
        
        
        //DESCOMENTAR CUANDO ESTE DISPONIBLE EL SERVIDOR
        /*
        // Petición POST al servidor
        let url = URL(string: "http://192.168.5.146:8080/VANET/environmentalIndicators/indicatorProcess")
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print("{\"vehicleId\":\"1\",\"timestamp\":\"\(fechaActual!)\",\"longitude\":\"-103.71252\",\"latitude\":\"19.26442\",\"envSearchRadius\":\"15\",\"vehicleIp\":\"100.123.121.100\"}")
        let postValues = "{\"vehicleId\":\"1\",\"timestamp\":\"\(fechaActual!)\",\"longitude\":\"-103.71252\",\"latitude\":\"19.26442\",\"envSearchRadius\":\"15\",\"vehicleIp\":\"100.123.121.100\"}"
        request.httpBody = postValues.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            
            do {
                self.jsonData = JSON(data: data!, options: [], error: nil)
                print("JSON=\(self.jsonData)")
                
                DispatchQueue.main.async {
                    self.comparacion(objeto: self.O3Label, valorLabel: self.O3valueLabel,valor: "1", color: 1)
                    self.comparacion(objeto: self.SO2Label, valorLabel: self.SO2valueLabel,valor: "2", color: 2)
                    self.comparacion(objeto: self.NO2Label, valorLabel: self.NO2valueLabel,valor: "3", color: 3)
                    self.comparacion(objeto: self.COLabel, valorLabel: self.COvalueLabel,valor: "4", color: 4)
                    self.comparacion(objeto: self.PM10Label, valorLabel: self.PM10valueLabel,valor: "5", color: 5)
                    self.comparacion(objeto: self.PM25Label, valorLabel: self.PM25valueLabel,valor: "6", color: 1)
                    print("La calidad general es: \(self.calidadGeneral)")
                    self.calidad(etiqueta: self.calidadLabel, view: self.calidadColorView, recomendacion: self.recomendacionesLabel, color: self.calidadGeneral)
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
            }
        }
        task.resume()
    */
    }
    func comparacion(objeto : UILabel, valorLabel : UILabel, valor : String, color : Int){
        if self.calidadGeneral < color {
            self.calidadGeneral = color
        }
        switch (color)
        {
        case 1:
            objeto.textColor = UIColor.green
            objeto.text = "Buena"
            valorLabel.text = valor
            
        case 2:
            objeto.textColor = UIColor.yellow
            objeto.text = "Regular"
            valorLabel.text = valor
            
        case 3:
            objeto.textColor = UIColor.orange
            objeto.text = "Mala"
            valorLabel.text = valor
            
        case 4:
            objeto.textColor = UIColor.red
            objeto.text = "Muy mala"
            valorLabel.text = valor
            
        case 5:
            objeto.textColor = UIColor.purple
            objeto.text = "Extr. Mala"
            valorLabel.text = valor
            
        default:
            objeto.textColor = UIColor.black
            objeto.text = "-"
            valorLabel.text = "-"
        }
    }
    func calidad(etiqueta : UILabel, view: UIView, recomendacion : UILabel, color : Int){
        if self.calidadGeneral < color {
            self.calidadGeneral = color
        }
        switch (color)
        {
        case 1:
            etiqueta.textColor = UIColor.green
            view.backgroundColor = UIColor.green
            etiqueta.text = "Buena"
            recomendacion.text = "Puede realizar actividades y ejercitarte al aire libre. Sin riesgo para grupo sensibles."
            
        case 2:
            etiqueta.textColor = UIColor.yellow
            view.backgroundColor = UIColor.yellow
            etiqueta.text = "Regular"
            recomendacion.text = "Puede realizar actividades y ejercitarte al aire libre. Limitar actividades para grupo sensibles."
            
        case 3:
            etiqueta.textColor = UIColor.orange
            view.backgroundColor = UIColor.orange
            etiqueta.text = "Mala"
            recomendacion.text = "Limitar las actividades y el tiempo de ejercicio al aire libre. Grupos sensibles permanecer en interiores."
            
        case 4:
            etiqueta.textColor = UIColor.red
            view.backgroundColor = UIColor.red
            etiqueta.text = "Muy mala"
            recomendacion.text = "Evita realizar actividades y ejercitarte al aire libre. Grupos sensibles permanecer en interiores. Manten cerradas puertas y ventanas. Acude al médico si presentas síntomas de enfermedades respiratorias o cardiovasculares. Permanecer atento a la informacion de la calidad del aire."
            
        case 5:
            etiqueta.textColor = UIColor.purple
            view.backgroundColor = UIColor.purple
            etiqueta.text = "Extr. Mala"
            recomendacion.text = "NO debes realizar actividades y ejercitarte al aire libre. Grupos sensibles permanecer en interiores. Manten cerradas puertas y ventanas. Acude inmediatamente al médico, o solicita servicio de emergencia si presentas síntomas de enfermedades respiratorias o cardiovasculares. Permanecer atento a la informacion de la calidad del aire."
            
        default:
            etiqueta.textColor = UIColor.green
            view.backgroundColor = UIColor.green
            etiqueta.text = "Buena"
            recomendacion.text = "Puede realizar actividades y ejercitarte al aire libre. Sin riesgo para grupo sensibles"
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
