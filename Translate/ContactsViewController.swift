//
//  ContactsViewController.swift
//  Translate
//
//  Created by Bryan Ye on 13/1/17.
//  Copyright © 2017 Bryan Ye. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, FetchData {

    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        DatabaseHelper.Instance.delegate = self
        
        DatabaseHelper.Instance.getContacts()
        
        // Do any additional setup after loading the view.
    }
    
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts
        
        tableView.reloadData()
    }

    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        if AuthHelper.Instance.logOut() {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ContactsViewController: UITableViewDelegate {
    
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = contact.name
        return cell
    }
}
