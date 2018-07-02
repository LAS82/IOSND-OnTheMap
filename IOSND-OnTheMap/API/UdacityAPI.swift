//
//  UdacityAPI.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation

class UdacityAPI {
    
    
    static func doLogin(email: String, password: String, completionHandler: @escaping (_ accountKey: String?, _ sessionId: String?, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        request.httpMethod = "POST"
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)! as Data
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            let result = API.executedWithSuccess(error: error, response: response, data: data, statusCodeMessage: "Email or password is invalid")
            
            guard result == "" else {
                completionHandler(nil, nil, "")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data!.subdata(in: Range(range)) /* subset response data! */
            
            /* Parse and use data */
            
            if let parsedResult = (try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments)) as? NSDictionary {
                
                let account = parsedResult["account"] as? [String:Any]
                let session = parsedResult["session"] as? [String:Any]
                
                let accountKey = account?["key"] as? String
                let sessionId = session?["id"] as? String
                
                completionHandler(accountKey, sessionId, nil)
            }
            
        }
        
        task.resume()
        
    }
    
    private static func setHeaderValuesForDoLogin() {
        
    }
    
    static func getStudentsLocation(completionHandler: @escaping (_ studentsData: [[String:AnyObject]]?, _ success: Bool, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        /* Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            let result = API.executedWithSuccess(error: error, response: response, data: data, statusCodeMessage: "Some error occurs while getting students locations")
            
            guard result == "" else {
                completionHandler(nil, false, result)
                return
            }
            
            /* Parse and use data */
            
            if let parsedResult = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String: AnyObject] {
                
                completionHandler(parsedResult["results"] as? [[String:AnyObject]], true, nil)
                
                return
            }
            
            completionHandler(nil, false, nil)
            
        }
        
        task.resume()
        
    }
    
}
