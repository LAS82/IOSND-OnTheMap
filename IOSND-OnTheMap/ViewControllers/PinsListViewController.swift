//
//  PinsListViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 07/07/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit

class PinsListViewController : UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getStudentsData()
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.sharedStudents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentCell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let studentTable = Students.sharedStudents[indexPath.row]
        
        studentCell.textLabel?.text = studentTable.firstName + " " + studentTable.lastName

        studentCell.detailTextLabel?.text = studentTable.mediaURL
        
        return studentCell
    }
    
    func showSimpleAlert(caption: String, text: String, okHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: caption, message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okHandler))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
