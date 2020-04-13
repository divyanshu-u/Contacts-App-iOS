//
//  RestoreContactsTableViewController.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 15/03/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.

import UIKit
import SwiftyJSON
import FirebaseStorage
import ContactsUI

class RestoreContactsTableViewController: UITableViewController {
    
    @IBOutlet weak var restoreButtonOutlet: UIButton!
    var contacts: [ResponseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var contactDetail: ResponseData = ResponseData()
        do {
            let bundlePath = Bundle.main.path(forResource: "ContactDetails",
            ofType: "json")
            if let fil = bundlePath
            {
                let file = URL(fileURLWithPath: fil)
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [Any]
                {
                    // json is an array
                    print(object.count)
                    for obj in object
                    {
                        let obj1 = obj as? Dictionary<String,Any>
                        if let obj1 = obj1{
                        contactDetail.name = obj1["name"] as? String
                        contactDetail.emailAddress = obj1["emailAddress"] as? String
                        contactDetail.jobTitle = obj1["jobTitle"] as? String
                        contactDetail.phoneNumber = obj1["phoneNumber"] as? String
                        
                        let imageData = obj1["avatar"] as? String
                            if(imageData != nil)
                            {
                        let dataDecoded:NSData = NSData(base64Encoded: imageData!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        contactDetail.avatar = dataDecoded as Data
                            }
                        contacts.append(contactDetail)
                        }
                    }
                }
                else
                {
                    print("JSON is invalid")
                }
            }
            else
            {
                print("no file")
            }
        }
        catch {
            print(error.localizedDescription)
        }
        print("Count: \(contacts.count)")
        if(contacts.count == 0)
        {
            restoreButtonOutlet.isEnabled = false
        }
                
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        cell.firstLabel.text = contacts[indexPath.row].name
        cell.secondLabel.text = contacts[indexPath.row].jobTitle
        cell.thirdLabel.text = contacts[indexPath.row].emailAddress
        cell.fourthLabel.text = contacts[indexPath.row].phoneNumber
        cell.tickBoxImage.image = nil
        if( contacts[indexPath.row].avatar != nil)
        {
            cell.avatarImage.image = UIImage(data: contacts[indexPath.row].avatar!)
        }
        return cell
    }
    func loadDataFromJson()
    {
        
        var contactDetail: ResponseData = ResponseData()
        
        do {
            let bundlePath = Bundle.main.path(forResource: "ContactDetails",
                                              ofType: "json")
            print(bundlePath!)
            if let fil = bundlePath {
                let file = URL(fileURLWithPath: fil)
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [Any]
                {
                    // json is an array
                    var i = 0
                    for _ in object
                    {
                        let obj1 = object[i] as? Dictionary<String,Any>
                        contactDetail.name = obj1!["name"] as? String
                        contactDetail.emailAddress = obj1!["emailAddress"] as? String
                        contactDetail.jobTitle = obj1!["jobTitle"] as? String
                        contactDetail.phoneNumber = obj1!["phoneNumber"] as? String
                        i = i + 1
                        let imageData = obj1!["avatar"] as? String
                        if(imageData != nil)
                        {
                        let dataDecoded:NSData = NSData(base64Encoded: imageData!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        contactDetail.avatar = dataDecoded as Data
                        }
                        contacts.append(contactDetail)
                    }
                }
                else
                {
                    print("JSON is invalid")
                }
            }
            else
            {
                print("no file")
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        print("Count: \(contacts.count)")
        
        tableView.reloadData()
    }
    
    @IBAction func restoreBtn(_ sender: Any) {
        
        print("Restore button pressed!!")
        
        print(contacts.count)
        for contact in contacts
        {
            let newContact = CNMutableContact()
            
            newContact.givenName = contact.name ?? ""
            newContact.jobTitle = contact.jobTitle ?? ""
            newContact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: (contact.emailAddress as? NSString ?? "") )]
            newContact.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: contact.phoneNumber ?? ""))]
            newContact.imageData = contact.avatar
            let request = CNSaveRequest()
            let store = CNContactStore()
            request.add(newContact, toContainerWithIdentifier: nil)
            do
            {
                try store.execute(request)
            }
            catch let error
            {
                print(error)
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
}
