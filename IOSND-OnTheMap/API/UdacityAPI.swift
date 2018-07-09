//
//  UdacityAPI.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation

class UdacityAPI {
    
    //MARK: - Login/Logout methods
    
    //Do the login with udacity's API
    static func doLogin(email: String, password: String, completionHandler: @escaping (_ accountKey: String?, _ sessionId: String?, _ errorMessage: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        request.httpMethod = "POST"
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)! as Data
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            let result = API.executedWithSuccess(error: error, response: response, data: data, statusCodeMessage: "Email or password is invalid")
            
            guard result == "" else {
                completionHandler(nil, nil, result)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data!.subdata(in: Range(range))
            
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
    
    //Do the logout with udacity's API
    static func doLogout(completionHandler: @escaping (_ errorMessage: String?) -> Void) {
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                completionHandler("Some problem occurs to do the logout. Try again.")
                return
            }
            
            completionHandler(nil)
            
        }
        
        task.resume()
        
    }
    
    //Get info about the logged user
    static func getLoggedUserData(completionHandler: @escaping  (_ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(User.sharedUser.accountkey)")!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            let result = API.executedWithSuccess(error: error, response: response, data: data, statusCodeMessage: "Some problem occurs while attempting to get user data.")
            
            guard result == "" else {
                completionHandler(result)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data!.subdata(in: Range(range))
            
            if let parsedResult = (try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments)) as? NSDictionary {
                
                let userData = parsedResult["user"] as! NSDictionary
                User.sharedUser.firstName = userData["first_name"] as! String
                User.sharedUser.lastName = userData["last_name"] as! String
                
            }
            
            completionHandler(nil)
            
        }
        
        task.resume()
        
    }
    
    //MARK: - Location methods methods
    
    //Gets a list with the 100 last updated students
    static func getStudentsLocation(completionHandler: @escaping (_ studentsData: [[String:AnyObject]]?, _ errorMessage: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            let result = API.executedWithSuccess(error: error, response: response, data: data, statusCodeMessage: "Some error occurs while getting students locations")
            
            guard result == "" else {
                completionHandler(nil, result)
                return
            }
            
            if let parsedResult = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String: AnyObject] {
                
                completionHandler(parsedResult["results"] as? [[String:AnyObject]], nil)
                
                return
            }
            
            completionHandler(nil, "No students data was returned")
            
        }
        
        task.resume()
        
    }
    
    //Set user's location and url
    static func setLoggedStudentLocation(completionHandler: @escaping (_ error: String?) -> Void) {
        
        let latitude: Double = (User.sharedUser.placemark?.location?.coordinate.latitude)!
        let longitude: Double = (User.sharedUser.placemark?.location?.coordinate.longitude)!
        
        print(latitude)
        print(longitude)
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(User.sharedUser.accountkey)\", \"firstName\": \"\(User.sharedUser.firstName)\", \"lastName\": \"\(User.sharedUser.lastName)\",\"mapString\": \"\(User.sharedUser.locationMapText)\", \"mediaURL\": \"\(User.sharedUser.url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            let result = API.executedWithSuccess(error: error, response: response, data: data, statusCodeMessage: "Some problem occurs while trying to post your location.")
            
            guard result == "" else {
                completionHandler(result)
                return
            }
            
            completionHandler(nil)
            
        }
        
        task.resume()
        
    }
    
}
