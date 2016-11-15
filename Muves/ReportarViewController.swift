//
//  ReportarViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 13/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class ReportarViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var siguienteButton: UIButton!
    @IBOutlet weak var accidenteCheckBox: CheckBox!
    @IBOutlet weak var calleCheckBox: CheckBox!
    @IBOutlet weak var retenCheckBox: CheckBox!
    @IBOutlet weak var bacheCheckBox: CheckBox!
    @IBOutlet weak var inundacionCheckBox: CheckBox!
    @IBOutlet weak var otroCheckBox: CheckBox!
    @IBOutlet weak var otroTextField: UITextField!
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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.window?.isUserInteractionEnabled = true
        self.navigationController?.view.window?.isUserInteractionEnabled = true
        self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        self.popoverPresentationController?.sourceRect = CGRect(x: 159, y: 200, width: 0, height: 0)
        
        //Hacer redondas las esquinas del boton Enviar
        siguienteButton.layer.cornerRadius = 5.0
        
        //Reiniciar los check box
        accidenteCheckBox.isChecked = false
        calleCheckBox.isChecked = false
        retenCheckBox.isChecked = false
        bacheCheckBox.isChecked = false
        inundacionCheckBox.isChecked = false
        otroCheckBox.isChecked = false
        
        //Colocar delegate del Text Field
        otroTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.otroTextField {
            self.view.endEditing(true)
        }
        return true
    }
    @IBAction func siguiente(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "direccionSegue", sender: self)
    }
    @IBAction func cancelar(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "direccionSegue" {
            let direccionViewController = segue.destination as! DireccionViewController
            //direccionViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            //direccionViewController.popoverPresentationController!.delegate = self
            if accidenteCheckBox.isChecked == true {checkBoxDictionary["accidente"] = true}
            if calleCheckBox.isChecked == true {checkBoxDictionary["calle"] = true}
            if retenCheckBox.isChecked == true {checkBoxDictionary["reten"] = true}
            if bacheCheckBox.isChecked == true {checkBoxDictionary["bache"] = true}
            if inundacionCheckBox.isChecked == true {checkBoxDictionary["inundacion"] = true}
            if otroCheckBox.isChecked == true {checkBoxDictionary["otro"] = true}
            
            direccionViewController.directionDictionary = directionDictionary
            direccionViewController.checkBoxDictionary = checkBoxDictionary
            direccionViewController.otroDato = otroTextField.text
        }
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
