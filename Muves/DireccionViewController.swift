//
//  ReportarViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 13/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class DireccionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var calleTextField: UITextField!
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var ciudadTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    var alert = UIAlertController(title: "Muchas gracias", message: "Tu reporte fue enviado correctamente", preferredStyle: UIAlertControllerStyle.alert)
    var directionDictionary: [String:String] = [
        "calle" : "",
        "numero" : "",
        "ciudad" :"",
        "estado" : ""
    ]
    var checkBoxDictionary: [String:Bool] = [
        "accidente" :false,
        "calle" : false,
        "reten" :false,
        "bache" : false,
        "inundacion" : false,
        "otro" : false
    ]
    var otroDato : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.window?.isUserInteractionEnabled = true
        self.navigationController?.view.window?.isUserInteractionEnabled = true
        self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        self.popoverPresentationController?.sourceRect = CGRect(x: 159, y: 200, width: 0, height: 0)
        
        //Hacer redondas las esquinas del boton Enviar
        enviarButton.layer.cornerRadius = 5.0
        
        //colocar los valores predefinidos en los Text Field
        calleTextField.text = directionDictionary["calle"]
        numeroTextField.text = directionDictionary["numero"]
        ciudadTextField.text = directionDictionary["ciudad"]
        estadoTextField.text = directionDictionary["estado"]
        
        //colocar el delegate de todos los textfield
        calleTextField.delegate = self
        numeroTextField.delegate = self
        ciudadTextField.delegate = self
        estadoTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.calleTextField {
            numeroTextField.becomeFirstResponder()
        }
        if textField == self.numeroTextField {
            ciudadTextField.becomeFirstResponder()
        }
        if textField == self.ciudadTextField {
            estadoTextField.becomeFirstResponder()
        }
        if textField == self.estadoTextField {
            self.view.endEditing(true)
        }
        return true
    }
    
    @IBAction func enviar(_ sender: AnyObject) {
        print(directionDictionary)
        print(checkBoxDictionary)
        print("otro: \(otroDato)")
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (self.dismissAlert), userInfo: nil, repeats: false)
    }
    func dismissAlert()
    {
        // Dismiss the alert from here
        alert.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func cancelar(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
