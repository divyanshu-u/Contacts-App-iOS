//
//  NewContactTableViewController.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 05/04/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.
//

import UIKit

class NewContactTableViewController: UITableViewController {

   
    
    var newContacts: [NewContacts] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
        if let coreDataUpdates =   try? context.fetch(NewContacts.fetchRequest()) as? [NewContacts]
               {
                 newContacts = coreDataUpdates
                }
        }

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newContacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("NC:\(newContacts.count)")
        let nib = UINib(nibName: "NewContactTableViewCell", bundle: nil)
               tableView.register(nib, forCellReuseIdentifier: "CustomCell2")
               let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell2") as! NewContactTableViewCell
        
        cell.nameLabel.text = newContacts[indexPath.row].name
        cell.phoneNumberLabel.text = newContacts[indexPath.row].phoneNumber
        cell.addressLabel.text = newContacts[indexPath.row].address
        
        return cell
    }
}
    

    
    

    
   
   



