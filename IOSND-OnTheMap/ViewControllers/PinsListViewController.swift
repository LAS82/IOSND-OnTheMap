//
//  PinsListViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 07/07/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

class PinsListViewController : UITableViewController {
    
    //MARK: - View Functions
    
    //Load students data and reload the table data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getStudentsData()
    }
    
    //MARK: - Action functions
    
    //Reset the list with new data
    @IBAction func refreshClick(_ sender: Any) {
        getStudentsData()
    }
    
    //MARK: - Do the logout on the app
    @IBAction func logoutClick(_ sender: Any) {
        doLogout()
    }
    
    //MARK: - Table View Functions
    
    //Returns the data length
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.sharedStudents.count
    }
    
    //Returns a populated cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentCell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let studentTable = Students.sharedStudents[indexPath.row]
        
        studentCell.textLabel?.text = studentTable.firstName + " " + studentTable.lastName

        studentCell.detailTextLabel?.text = studentTable.mediaURL
        
        return studentCell
    }
    
    //Touch event tha opens safari with the url
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIApplication.shared.openURL(URL(string: Students.sharedStudents[indexPath.row].mediaURL)!)
        
    }
    
    //MARK: - Other functions
    
    //Gets the students data
    func getStudentsData() {
        
        UdacityAPI.getStudentsLocation(){ (studentsData, error) in
            
            guard error == nil || error == "" else {
                
                self.showSimpleAlert(caption: "List", text: error!, okHandler: nil)
                
                return
            }
            
            performUIUpdatesOnMain {
                Students.sharedStudents.removeAll()
                
                for result in studentsData! {
                    _ = Students.addStudentToList(student: result)
                }
                
                self.tableView.reloadData()
            }
            
        }
    }
    
}
