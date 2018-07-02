//
//  API.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation

class API {
    
    static func executedWithSuccess(error: Error?, response: URLResponse?, data: Data?, statusCodeMessage: String) -> String {
        
        
        guard (error == nil) else {
            return "An error occurs"
        }
        
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            return statusCodeMessage
        }
        
        
        guard data != nil else {
            return "No data was returned"
        }
        
        return ""
        
    }
    
}
