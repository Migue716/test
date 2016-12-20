//
//  TareasViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 14/12/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class TareasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    var sections = [Section]()
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    // La siguiente función está deshabilitada porque si se utiliza bloquea el despliegue de las celdas
    func TapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        //gestureRecognizer.view?.tag = 1
        print("Presiono el header de la seccion \(gestureRecognizer.view!.tag)")
        if gestureRecognizer.view!.tag == 0 {
            self.performSegue(withIdentifier: "usuarioSegue", sender: self)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell: TareasCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TareasCV", for: indexPath as IndexPath) as! TareasCollectionViewCell
        Cell.tareasView.layer.cornerRadius = 5.0
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tarea con # \(indexPath.row)")
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
//
// MARK: - View Controller DataSource and Delegate
//
extension TareasViewController {
    
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
        //self.performSegue(withIdentifier: "usuarioSegue", sender: self)
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
extension TareasViewController: CollapsibleTableViewHeaderDelegate {
    
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
