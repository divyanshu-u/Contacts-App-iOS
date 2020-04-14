//
//  TableViewController.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 11/03/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.
//

import UIKit
import ContactsUI
import FirebaseStorage
import ViewAnimator
import DCAnimationKit
import ChainableAnimations

//var checked: [Int]
class TableViewController: UITableViewController {
    
    
    @IBOutlet var uploadButtonOutlet: UITableView!
    
    var details: [ContactDetails] = []
    
    var cells:[CustomCell]! = []//initialize array at class level

    @IBOutlet weak var uploadButton: UIButton!
    var fm = FileManager()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.isEnabled = false
        let contacts = self.getContactFromCNContact()
        for _ in contacts {
            view.backgroundColor = .cyan


        }
    }
        
        func getContactFromCNContact() -> [CNContact] {

            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactGivenNameKey,
                CNContactMiddleNameKey,
                CNContactFamilyNameKey,
                CNContactEmailAddressesKey,
                CNContactJobTitleKey,
                CNContactThumbnailImageDataKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataKey
                ] as [Any]

            //Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
                
            } catch {
                print("Error fetching containers")
            }

            var results: [CNContact] = []

            // Iterate all containers and append their contacts to our results array
            for container in allContainers {

                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)

                } catch {
                    print("Error fetching results for container")
                }
            }
            return results
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = getContactFromCNContact()
        return results.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let results = getContactFromCNContact()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        
        cell.firstLabel.text = results[indexPath.row].givenName + " " + results[indexPath.row].middleName + " " + results[indexPath.row].familyName
        
   
        
        if results[indexPath.row].jobTitle != "label"
        {
        cell.secondLabel.text = results[indexPath.row].jobTitle
          
        }
        
        if results[indexPath.row].emailAddresses.first?.value != nil
        {
            cell.thirdLabel.text =  results[indexPath.row].emailAddresses.first?.value as? String
        }
        
        if results[indexPath.row].phoneNumbers.first != nil
        {
            cell.fourthLabel.text = results[indexPath.row].phoneNumbers.first?.value.stringValue
        }
        
          if let imageData = results[indexPath.row].imageData
          {
           print(type(of: results[indexPath.row].imageData)) 
            cell.avatarImage?.image = UIImage(data: imageData)
            
           let img = Image(withImage: (cell.avatarImage?.image)!)
            
        }
        cell.tickBoxImage.image = UIImage(named: "notTicked")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.tickBoxImage.isUserInteractionEnabled = true
        cell.tickBoxImage.addGestureRecognizer(tapGestureRecognizer)
        cells.append(cell)
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let cells = tableView.visibleCells

        let animator = ChainableAnimator(view: cells[indexPath.row].contentView)
       animator.move(x: 2.0).thenAfter(t: 1.0).make(scale: 1.1).spring.animate(t: 10.0)
    }

    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        
        uploadButton.isEnabled = true
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)

        tappedImage.animate(animations: [rotateAnimation])

        
           if tappedImage.image == UIImage(named: "notTicked")
           {
        
         tappedImage.image = UIImage(named: "ticked")
            

        }
           else{
        tappedImage.image = UIImage(named: "notTicked")
        }

        
        
    }
    
    @IBAction func uploadButton(_ sender: Any)
    
    {
        
        var conDetail: ContactDetails! = ContactDetails(tick: 0)
        
        // Added a comment here
        for cell in cells
        {
            if cell.tickBoxImage.image == UIImage(named: "ticked")
            {
                var count = UserDefaults.standard.integer(forKey: "Count")
                count = count + 1
                UserDefaults.standard.set(count, forKey: "Count")
                conDetail.name = cell.firstLabel.text
                conDetail.jobTitle = cell.secondLabel.text!
                conDetail.emailAddress = cell.thirdLabel.text!
                conDetail.phoneNumber = cell.fourthLabel.text!
                if cell.avatarImage?.image != nil
                {
                    let image = cell.avatarImage.image?.pngData()
                    conDetail.avatar = image
                }
                details.append(conDetail)
                
                
                
                
            }
        }
        print(details.count)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
            let bundlePath = Bundle.main.path(forResource: "ContactDetails",
            ofType: "json")
        if(bundlePath != nil)
        {
            let pathURL = URL(fileURLWithPath: bundlePath!)
        if
          let data = try? encoder.encode(details),
          let jsonString = String(data: data, encoding: .utf8) {
          try! jsonString.write(to: pathURL, atomically: false, encoding: .utf8)
        }
        
        FirebaseStorageManager().uploadFile(localFile: pathURL, serverFileName: "ContactDetails.json") { (isSuccess, url) in
            print("uploadImageData: \(isSuccess), \(url)")
        }
    }
        

        navigationController?.popViewController(animated: true)
    }
      
        
      }
    
        
        
        
    


