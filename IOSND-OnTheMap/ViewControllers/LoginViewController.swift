//
//  ViewController.swift
//  IOSND-OnTheMap
//
//  Created by Leandro Alves Santos on 24/06/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
 
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertOkClicked(_ alert: UIAlertAction?) {
        performUIUpdatesOnMain {
            self.enableViewFields(true)
        }
    }

    @IBAction func loginClick(_ sender: Any) {
        
        enableViewFields(false)
        
        if(!checkInputIsValid()) {
            return
        }
        
        UdacityAPI.doLogin(email: email.text!, password: password.text!) { (accountKey, sessionId, error) in
            
            guard error == nil else {
                    
                self.showSimpleAlert(caption: "Login Failed", text: "Email or password is invalid.", okHandler: self.alertOkClicked)
                
                return
            }
            
            let sharedUser = User.shared()
            sharedUser.accountkey = accountKey!
            sharedUser.sessionId = sessionId!
            
            performUIUpdatesOnMain {
                self.enableViewFields(true)
                
                self.performSegue(withIdentifier: "NavigatesToAppFeatures", sender: self)
            }
            
        }
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        
        UIApplication.shared.open(URL(string : "https://auth.udacity.com/sign-up")!, options: [:], completionHandler:
            {
                (status) in
                
                if !status {
                    self.showSimpleAlert(caption: "Sign Up Failed", text: "Could not open Udacity's sign up page on Safari.", okHandler: self.alertOkClicked)
                }
        })
        
    }
    
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

