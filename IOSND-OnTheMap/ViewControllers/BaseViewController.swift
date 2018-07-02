//
//  DefaultViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
 
class BaseViewController : UIViewController, UITextFieldDelegate {
    
    func showSimpleAlert(caption: String, text: String, okHandler: ((UIAlertAction) -> Void)?) {
    
        let alert = UIAlertController(title: caption, message: text, preferredStyle: UIAlertControllerStyle.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okHandler))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
