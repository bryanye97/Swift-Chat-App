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
    
    private let loginToContactsSegue = "loginToContacts"

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthHelper.Instance.login(email: email, password: password, loginHandler: { (message) in
                
                if message != nil {
                    self.alertUser(title: "Problem with Authentication", message: message!)
                } else {
                    print("LOGIN COMPLETED")
                }
//                self.performSegue(withIdentifier: self.loginToContactsSegue, sender: self)
            })
        }
    }

    @IBAction func register(_ sender: UIButton) {
    }
    
    private func alertUser(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
