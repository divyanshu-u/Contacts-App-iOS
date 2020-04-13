//
//  ViewController.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 11/03/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.
//

import UIKit
import ContactsUI



class ViewController: UIViewController {
    
    @IBOutlet weak var restoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(0, forKey: "Count")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.integer(forKey: "Count") == 0
        {
                restoreButton.isEnabled = false
        }
        else
        {
            restoreButton.isEnabled = true
        }
}
    
    @IBAction func importButton(_ sender: Any) {
    }
    
    @IBAction func downloadButton(_ sender: Any) {
        
    }
    @IBAction func deleteButton(_ sender: Any) {
        
        
        self.deleteAllContacts()
    }
    
    @IBAction func addContactButton(_ sender: Any) {
    }
    func deleteAllContacts() {
        let contactStore = CNContactStore()
        var cnContacts: [CNContact]? = nil

        contactStore.requestAccess(for: .contacts, completionHandler: { granted, error in
            if granted == true {
                let keys = [CNContactPhoneNumbersKey]
                let containerId = contactStore.defaultContainerIdentifier()
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
                var error: Error?
                do {
                    print("Executed do")
                    cnContacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
                } catch {
                    print("This error")
                    print(error)
                }
            }
                if error != nil {
                    if let error = error {
                        print("error fetching contacts \(error)")
                    }
                }
                else
                {
                    let saveRequest = CNSaveRequest()
                    for contact in cnContacts ?? [] {
                        
                        let mutableContact = contact.mutableCopy() as! CNMutableContact
                        saveRequest.delete(mutableContact)
                    }
                    
                    do {
                        try contactStore.execute(saveRequest)
                    }
                    catch {
                    }
                }
            
        })
        
    }
    
    
    
}














