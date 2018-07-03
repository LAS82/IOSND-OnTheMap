//
//  LoggedUser.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation

//Represents the logged user
class User {
    
    //User instance property
    static var sharedUser: User = User()
    
    //The account key
    var accountkey: String
    
    //The Session Id
    var sessionId: String
    
    //Class constructor
    private init() {
        accountkey = ""
        sessionId = ""
    }
    
    //The singleton
    class func shared() -> User {
        return sharedUser
    }
    
}
