//
//  ViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
 
class LoginViewController: BasicViewController {
    
    //MARK: - Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
 

    //MARK: - Actions
    
    //Do the login at udacity.
    @IBAction func loginClick(_ sender: Any) {
        
        enableViewFields(false)
        
        if(!checkInputIsValid()) {
            return
        }
        
        UdacityAPI.doLogin(email: email.text!, password: password.text!) { (accountKey, sessionId, error) in
            
            guard error == nil else {
                    
                self.showSimpleAlert(caption: "Login Failed", text: error!, okHandler: self.alertOkClicked)
                
                return
            }
            
            let sharedUser = User.shared()
            sharedUser.accountkey = accountKey!
            sharedUser.sessionId = sessionId!
            
            UdacityAPI.getLoggedUserData() {(errorMessage: String?) in
                
                guard error == nil else {
                    self.showSimpleAlert(caption: "Login Failed", text: errorMessage!, okHandler: self.alertOkClicked)
                    
                    return
                }
                
                performUIUpdatesOnMain {
                    
                    self.enableViewFields(true)
                    self.performSegue(withIdentifier: "NavigatesToAppFeatures", sender: self)
                    
                }
                
            }
            
        }
    }
    
    //Open the Udacity's sign up page
    @IBAction func signUpClick(_ sender: Any) {
        
        UIApplication.shared.open(URL(string : "https://auth.udacity.com/sign-up")!, options: [:], completionHandler:
            {
                (status) in
                
                if !status {
                    self.showSimpleAlert(caption: "Sign Up Failed", text: "Could not open Udacity's sign up page on Safari.", okHandler: self.alertOkClicked)
                }
        })
        
    }
    
    //MARK: - Other functions
    
    //Verify user inputs
    func checkInputIsValid() -> Bool {
        
        guard email.text != "" else {
            showSimpleAlert(caption: "Login Failed", text: "An email is required.", okHandler: alertOkClicked)
            return false
        }
        
        guard password.text != "" else {
            showSimpleAlert(caption: "Login Failed", text: "A password is required.", okHandler: alertOkClicked)
            return false
        }

        return true
        
    }
    
    //Executed after alert's OK button is clicked
    func alertOkClicked(_ alert: UIAlertAction?) {
        performUIUpdatesOnMain {
            self.enableViewFields(true)
        }
    }
    
    //Enables or disables the fields
    func enableViewFields(_ enabled: Bool) {
        email.isEnabled = enabled
        password.isEnabled = enabled
        loginButton.isEnabled = enabled
        signUpButton.isEnabled = enabled
        
        if enabled {
            loginButton.setTitle("LOG IN", for: .normal)
        }
        else {
            loginButton.setTitle("WAIT...", for: .normal)
        }
    }
}

