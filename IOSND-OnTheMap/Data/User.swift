//
//  LoggedUser.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation

class User {
    
    static var sharedUser: User = User()
    
    var accountkey: String
    var sessionId: String
    
    private init() {
        accountkey = ""
        sessionId = ""
    }
    
    class func shared() -> User {
        return sharedUser
    }
    
}
