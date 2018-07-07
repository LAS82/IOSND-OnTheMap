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
    
    var placemark: CLPlacemark?
    
    var url: String
    
    //Class constructor
    private init() {
        accountkey = ""
        sessionId = ""
        placemark = nil
        url = ""
    }
    
    //The singleton
    class func shared() -> User {
        return sharedUser
    }
    
}
