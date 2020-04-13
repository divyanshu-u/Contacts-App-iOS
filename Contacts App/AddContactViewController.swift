//
//  AddContactViewController.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 04/04/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    var newContactDetail = NewContacts()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addContactButton(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let newContactDetail = NewContacts(context: context)
            if let name = nameTextField.text
            {
                newContactDetail.name = name
            }
            if let phoneNumber = phoneNumberTextField.text
            {
                newContactDetail.phoneNumber = phoneNumber
            }
            if let address = addressTextField.text
            {
                newContactDetail.address = address
            }
            
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            navigationController?.popViewController(animated: true)
    }
    

}
}
