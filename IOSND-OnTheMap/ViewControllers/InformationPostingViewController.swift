//
//  InformationPostingViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 07/07/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController : BasicViewController {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBAction func cancelClick(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func findLocationClicked(_ sender: Any) {
        enableViewFields(false)
        
        if (!checkInputIsValid()) {
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location.text!, completionHandler: { (results, error) in
            
            guard error == nil else {
                self.showSimpleAlert(caption: "Add Location", text: "Some problem occurs while trying to get your location.", okHandler: self.alertOkClicked)
                
                return
            }
            
            guard !(results!.isEmpty) else {
                self.showSimpleAlert(caption: "Add Location", text: "No locations match your typed location.", okHandler: self.alertOkClicked)
                
                return
            }
            
            User.sharedUser.placemark = results![0]
            User.sharedUser.url = self.url.text!
            
            let resultView = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationConfirmation") as? ConfirmationController
            
            self.present(resultView!, animated: true, completion: nil)
            
        })
        
        enableViewFields(true)
    }
    
    func checkInputIsValid() -> Bool {
        
        guard location.text != "" else {
            showSimpleAlert(caption: "Add Location", text: "Type a location to proceed.", okHandler: alertOkClicked)
            return false
        }
        
        guard url.text != "" else {
            showSimpleAlert(caption: "Add Location", text: "Type a URL to proceed.", okHandler: alertOkClicked)
            return false
        }
        
        return true
        
    }
    
    func alertOkClicked(_ alert: UIAlertAction?) {
        performUIUpdatesOnMain {
            self.enableViewFields(true)
        }
    }
    
    func enableViewFields(_ enabled: Bool) {
        url.isEnabled = enabled
        location.isEnabled = enabled
        findLocationButton.isEnabled = enabled
    }
    
}
