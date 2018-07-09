//
//  LoggedUser.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation
import MapKit

//Represents the logged user
class User {
    
    //User instance property
    static var sharedUser: User = User()
    
    //The account key
    var accountkey: String
    
    //The Session Id
    var sessionId: String
    
    //Placemark selected by the user
    var placemark: CLPlacemark?
    
    //User's typed URL
    var url: String
    
    //User first name
    var firstName: String
    
    //User last name
    var lastName: String
    
    //Location typed by the user
    var locationMapText: String
    
    //Class constructor
    private init() {
        accountkey = ""
        sessionId = ""
        placemark = nil
        locationMapText = ""
        url = ""
        
        firstName = ""
        lastName = ""
    }
    
    //The singleton
    class func shared() -> User {
        return sharedUser
    }
    
}
