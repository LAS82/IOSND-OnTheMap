//
//  Students.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 30/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//
 
import Foundation

//Represents a student
struct Student {
    
    //Date that the register was created
    let createdAt: String!
    
    //Students first name
    let firstName: String!
    
    //Students last name
    let lastName: String!
    
    //Students pin latitude position
    let latitude: Double!
    
    //Students pin longitude position
    let longitude: Double!
    
    let mapString: String!
    
    //The student's website
    let mediaURL: String!
    
    //The register id
    let objectId: String!
    
    //Other register id
    let uniqueKey: String!
    
    //Date that the register was updated (the last update)
    let updatedAt: String!
    
    //Constructor
    init(_ createdAt_: String!,
         _ firstName_: String!,
         _ lastName_: String!,
         _ latitude_: Double!,
         _ longitude_: Double!,
         _ mapString_: String!,
         _ mediaURL_: String!,
         _ objectId_: String!,
         _ uniqueKey_: String!,
         _ updatedAt_: String!) {
        
         createdAt = createdAt_
         firstName = firstName_
         lastName = lastName_
         latitude = latitude_
         longitude = longitude_
         mapString = mapString_
         mediaURL = mediaURL_
         objectId = objectId_
         uniqueKey = uniqueKey_
         updatedAt = updatedAt_
    }
}

//Represents a list of students pins
class Students {
    
    //Students array
    static var sharedStudents = [Student]()
    
    //Add a student to the list of students if latitude and longitude was set
    //Returns an bool indicating the student's addition to the list
    static func addStudentToList(student: [String: AnyObject]) -> Bool {
        
        let createdAt = student["createdAt"] as? String
        let firstName = student["firstName"] as? String
        let lastName = student["lastName"] as? String
        let latitude = student["latitude"] as? Double
        let longitude = student["longitude"] as? Double
        let mapString = student["mapString"] as? String
        let mediaURL = student["mediaURL"] as? String
        let objectId = student["objectId"] as? String
        let uniqueKey = student["uniqueKey"] as? String
        let updatedAt = student["updatedAt"] as? String
        
        guard(latitude != nil && longitude != nil) else {
            return false
        }
        
        Students.sharedStudents.append(Student(
            createdAt,
            firstName,
            lastName,
            latitude,
            longitude,
            mapString,
            mediaURL,
            objectId,
            uniqueKey,
            updatedAt
        ))
        
        return true
    }
}
