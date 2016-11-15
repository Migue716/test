//
//  AlertasViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 12/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class AlertasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var alertasTableView: UITableView!
    let imagenes : [String] = ["locacion", "lupa", "palomita"]
    let nombres : [String] = ["uno", "dons", "tres"]
    let descripciones : [String] = ["Students from @ITCH_Comunica have designed a race car & won 3rd place in the cost category of the Formula SAE series bit.ly/2fUE9Kj", "El Instituto Tecnológico de Chihuahua diseña un auto de carreras y consigue un tercer lugar en la serie Fórmula SAE bit.ly/2fRwFFq","El Instituto Tecnológico de Chihuahua diseña un auto de carreras y consigue un tercer lugar en la serie Fórmula SAE bit.ly/2fRwFFq"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //Colocar la vista de Menu en frente
        self.view.bringSubview(toFront: menuView)
        
        //Programar gesto para que se abra el Menu si tocas una parte limpia de la barra
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.abrirMenuButton(_:)))
        self.menuView.addGestureRecognizer(gesture)
        
        alertasTableView.layer.cornerRadius = 5.0
        alertasTableView.separatorColor = UIColor.black
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertasCell", for: indexPath as IndexPath) as! AlertasTableViewCell
        cell.twitterImageView.image = UIImage(named: imagenes[indexPath.row])
        cell.twitterUsuarioLabel.text = nombres[indexPath.row]
        cell.twitterDescripcionLabel.text = descripciones[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seleccionaste la fila #\(indexPath.row)!")
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
