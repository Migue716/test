//
//  CheckBox.swift
//  checkbox
//
//  Created by kent on 9/27/14.
//  Copyright (c) 2014 kent. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    var restaurantID = ""
    var token = ""
    //images
    let checkedImage = UIImage(named: "checked_checkbox")
    let unCheckedImage = UIImage(named: "unchecked_checkbox")
    
    //bool propety
    var isChecked:Bool = false{
        didSet{
            if isChecked == true{
                self.setImage(checkedImage, for: .normal)
            }else{
                self.setImage(unCheckedImage, for: .normal)
            }
        }
    }

    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector (self.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    


    func buttonClicked(sender:UIButton) {
        if(sender == self){
            if isChecked == true{
                isChecked = false
                print("CheckBox NO marcado")
             
            }else{
                isChecked = true
                print("CheckBox marcado")
                            }
        }
    }

}
