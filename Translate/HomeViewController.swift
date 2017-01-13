//
//  HomeViewController.swift
//  Translate
//
//  Created by Bryan Ye on 13/1/17.
//  Copyright © 2017 Bryan Ye. All rights reserved.
//

import UIKit

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
    
    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: loginToContactsSegue, sender: nil)
    }

    @IBAction func register(_ sender: UIButton) {
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
