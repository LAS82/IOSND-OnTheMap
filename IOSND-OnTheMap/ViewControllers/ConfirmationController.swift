//
//  ConfirmationController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 07/07/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
import MapKit

class ConfirmationController : BasicViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        map.showAnnotations([MKPlacemark(placemark: User.sharedUser.placemark!)], animated: true)
        
    }
    
    @IBAction func addLocationClick(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
