//
//  PhoneContact.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 11/03/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.
//

import UIKit

struct Image: Codable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            print("No image??")
            return nil
        }
        print("No it's converted")
        let image = UIImage(data: imageData)
        
        return image
    }
}


struct ContactDetails : Codable {
    var name: String?
    var jobTitle : String?
    var emailAddress : String?
    var phoneNumber: String?
    var avatar: Data?
    var tick: Int?
}

struct ResponseData: Decodable {
    var name: String?
    var jobTitle : String?
    var emailAddress : String?
    var phoneNumber: String?
    var avatar: Data?
    var tick: Int?
}
