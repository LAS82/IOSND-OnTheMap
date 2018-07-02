//
//  MapViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 30/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
import MapKit
 
class MapViewController : BaseViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UdacityAPI.getStudentsLocation(){ (studentsData, success, error) in
            
            guard success == true else {
                
                self.showSimpleAlert(caption: "Map", text: error!, okHandler: nil)
                
                return
            }
            
            performUIUpdatesOnMain {
                self.setStudentsAnnotationsOnMap(studentsData: studentsData!)
            }
            
        }
    }
    
    func setStudentsAnnotationsOnMap(studentsData: [[String:AnyObject]]) {
        
        self.map.removeAnnotations(self.map.annotations)
        
        for result in studentsData {
            if Students.addStudentToList(student: result) {
                let lastAddedStudent = Students.sharedStudents[Students.sharedStudents.count - 1]
                
                annotations.append(configAnnotation(student: lastAddedStudent))
            }
        }
        
        self.map.addAnnotations(annotations)
    }
    
    func configAnnotation(student: Student) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        
        let lat = CLLocationDegrees(student.latitude as Double)
        let long = CLLocationDegrees(student.longitude as Double)
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        annotation.title = "\(student.firstName!) \(student.lastName!)"
        annotation.subtitle = student.mediaURL!
        
        return annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pinIdent"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
}
