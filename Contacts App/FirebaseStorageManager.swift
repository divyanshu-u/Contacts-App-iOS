//
//  FirebaseStorageManager.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 16/03/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage


class FirebaseStorageManager {

public func uploadFile(localFile: URL, serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
    
    let storage = Storage.storage()
    let storageRef = storage.reference()
    // Create a reference to the file you want to upload
    let fileRef = storageRef.child("ContactDetails.json")

    _ = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
        fileRef.downloadURL { (url, error) in
            print(url)
            guard let downloadURL = url else {
                // Uh-oh, an error occurred!
                completionHandler(false, nil)
                return
            }
            // File Uploaded Successfully
            completionHandler(true, downloadURL.absoluteString)
        }
    }
}
}
