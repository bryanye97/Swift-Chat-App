//
//  HomeViewController.swift
//  Translate
//
//  Created by Bryan Ye on 13/1/17.
//  Copyright © 2017 Bryan Ye. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private let logInToContactsSegue = "logInToContacts"
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthHelper.Instance.isLoggedIn() {
            self.performSegue(withIdentifier: self.logInToContactsSegue, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email != "" && password != "" {
            
            AuthHelper.Instance.logIn(email: email, password: password, loginHandler: { (message) in
                
                if message != nil {
                    self.alertUser(title: "Problem with Authentication", message: message!)
                } else {
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    print("Logging in")
                    self.performSegue(withIdentifier: self.logInToContactsSegue, sender: self)
                }
            })
        } else {
            alertUser(title: "Email and Password are required.", message: "Please enter email and password in the fields")
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email != "" && password != "" {
            AuthHelper.Instance.register(email: email, password: password, loginHandler: { (message) in
                if message != nil {
                    self.alertUser(title: "Problem Creating New User", message: message!)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    print("Logging in")
                    self.performSegue(withIdentifier: self.logInToContactsSegue, sender: self)
                }
                
            })
            
        } else {
            alertUser(title: "Email and Password are required.", message: "Please enter email and password in the fields")
        }
    }
    
    private func alertUser(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
}
