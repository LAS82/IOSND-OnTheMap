//
//  UIViewControllerExtension.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 07/07/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Shows an alert to the user.
    func showSimpleAlert(caption: String, text: String, okHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: caption, message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okHandler))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Logout in Udacity's API
    func doLogout() {
        UdacityAPI.doLogout() {(errorMessage: String?) in
            
            if errorMessage == nil || errorMessage == "" {
                
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                
                self.showSimpleAlert(caption: "Error", text: errorMessage!, okHandler: nil)
                
            }
            
        }
    }
    
}
