//
//  TwitterViewController.swift
//  Muves
//
//  Created by Ramses Miramontes Meza on 12/10/16.
//  Copyright © 2016 Ramses Miramontes Meza. All rights reserved.
//

import UIKit

class TwitterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var flechaUIButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var twitterTableView: UITableView!
    var jsonData : JSON!
    var totalTweets : Int = 0
    var imageCache = [String:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Colocar la vista de Menu en frente
        self.view.bringSubview(toFront: menuView)
        
        //Programar gesto para que se abra el Menu si tocas una parte limpia de la barra
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.abrirMenuButton(_:)))
        self.menuView.addGestureRecognizer(gesture)
        
        twitterTableView.layer.cornerRadius = 5.0
        twitterTableView.separatorColor = UIColor.black
        
        downloadData()
        
        // Implementar Pull to Refresh a la tabla
        let refreshControl = UIRefreshControl()
        twitterTableView.addSubview(refreshControl)
        let RefreshControlColor = UIColor(red: 230.0/255.0, green: 74.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        refreshControl.tintColor = RefreshControlColor
        /*let RefreshTitleText = "Actualizando restaurantes" as NSString
         let attributedString = NSMutableAttributedString(string: RefreshTitleText as String)
         let firstAttributes = [NSForegroundColorAttributeName: RefreshControlColor, NSBackgroundColorAttributeName: UIColor.clearColor(), NSUnderlineStyleAttributeName: 0]
         attributedString.addAttributes(firstAttributes, range: RefreshTitleText.rangeOfString("Actualizando sensores"))
         refreshControl.attributedTitle = attributedString*/
        refreshControl.addTarget(self, action: #selector (self.UpdateTable(refreshControl:)), for: .valueChanged)
    }
    func UpdateTable(refreshControl: UIRefreshControl) {
        downloadData()
        twitterTableView.reloadData()
        print("tabla actualizada")
        refreshControl.endRefreshing()
    }
    func downloadData() {
        // Petición GET al servidor
        let url = URL(string: "http://192.168.5.196/muves2web/api/twitter/getJsonTwitter")
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        
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
                    self.totalTweets = self.jsonData.count
                    self.twitterTableView.reloadData()
                }
                /*if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                 
                 //print("success == \(responseDictionary)")
                 
                 // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                 //
                 DispatchQueue.main.async {
                 print("Recargo datos")
                 }
                 
                 }*/
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalTweets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "twitterCell", for: indexPath as IndexPath) as! TwitterTableViewCell
        cell.twitterUsuarioLabel.text = jsonData[indexPath.row]["user_screen_name"].stringValue
        cell.twitterDescripcionLabel.text = jsonData[indexPath.row]["text"].stringValue
        
        // If this image is already cached, don't re-download
        let urlString = jsonData[indexPath.row]["user_profile_image_url"].stringValue
        let imgURL = NSURL(string: urlString)
        if let img = imageCache[urlString] {
            cell.twitterImageView.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            var request2 = URLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
            request2.httpMethod = "GET"
            request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request2.addValue("application/json", forHTTPHeaderField: "Accept")

            let task2 = URLSession.shared.dataTask(with: request2) {data, response, error in
                if error != nil {
                    // handle error here
                    print("Error al principio")
                    print(error!.localizedDescription)
                    return
                }
                
                // if response was JSON, then parse it
                
                do {
                    let image = UIImage(data: data!)
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    
                    DispatchQueue.main.async {
                        cell.twitterImageView.image = image
                    }
                    /*if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                     
                     //print("success == \(responseDictionary)")
                     
                     // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                     //
                     DispatchQueue.main.async {
                     print("Recargo datos")
                     }
                     
                     }*/
                } catch {
                    print(error)
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(responseString)")
                }
            }
            task2.resume()
        }
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seleccionaste la fila #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
