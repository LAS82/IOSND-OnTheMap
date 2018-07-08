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
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        map.isHidden = true
        finishButton.isHidden = true
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        
        if map.isHidden {
            dismiss(animated: true, completion: nil)
        }
        else {
            
            self.location.isHidden = false
            self.url.isHidden = false
            self.findLocationButton.isHidden = false
            
            self.finishButton.isHidden = true
            self.map.isHidden = true
        }
        
    }
    
    @IBAction func finishClick(_ sender: Any) {
    
        UdacityAPI.setLoggedStudentLocation() { (errorMessage: String?) in
         
            guard errorMessage == nil else {

                 self.showSimpleAlert(caption: "Ad Location", text: errorMessage!, okHandler: nil)
                 return

            }
         
            self.dismiss(animated: true, completion: nil)
            
         }
        
    }
    
    
    @IBAction func findLocationClick(_ sender: Any) {
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
            User.sharedUser.locationMapText = self.location!.text!
            User.sharedUser.url = self.url.text!
            
            
            self.location.isHidden = true
            self.url.isHidden = true
            self.findLocationButton.isHidden = true
            
            self.finishButton.isHidden = false
            self.map.isHidden = false
            
            self.map.showAnnotations([MKPlacemark(placemark: User.sharedUser.placemark!)], animated: true)
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
