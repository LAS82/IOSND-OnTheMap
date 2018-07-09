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
    
    @IBOutlet weak var activityIndicatorGeo: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        showMap(false)
        loading(false)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        
        if map.isHidden {
            dismiss(animated: true, completion: nil)
        }
        else {
            
            showMap(false)
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
    
    func loading(_ loading: Bool) {
        
        if loading {
            activityIndicatorGeo.startAnimating()
            activityIndicatorGeo.isHidden = false
        }
        else {
            activityIndicatorGeo.stopAnimating()
            activityIndicatorGeo.isHidden = true
        }
        
    }
    
    
    @IBAction func findLocationClick(_ sender: Any) {
        
        loading(true)
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
            
            self.showMap(true)
            
            self.map.showAnnotations([MKPlacemark(placemark: User.sharedUser.placemark!)], animated: true)
            
            self.loading(false)
            self.enableViewFields(true)
        })
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
            self.loading(false)
            self.enableViewFields(true)
        }
    }
    
    func enableViewFields(_ enabled: Bool) {
        url.isEnabled = enabled
        location.isEnabled = enabled
        findLocationButton.isEnabled = enabled
    }
    
    func showMap(_ show: Bool) {
        
        self.location.isHidden = show
        self.url.isHidden = show
        self.findLocationButton.isHidden = show
        
        self.finishButton.isHidden = !show
        self.map.isHidden = !show
        
    }
    
}
