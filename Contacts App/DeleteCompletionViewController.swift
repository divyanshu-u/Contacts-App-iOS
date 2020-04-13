//
//  DeleteCompletionViewController.swift
//  Contacts App
//
//  Created by Divyanshu Upadhyay on 19/03/20.
//  Copyright © 2020 Divyanshu Upadhyay. All rights reserved.


import UIKit
import ChainableAnimations
import DCAnimationKit

class DeleteCompletionViewController: UIViewController {

    @IBOutlet weak var deleteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteLabel.swing(nil)
        
        perform(#selector(viewWillAppear(_:)), with: nil, afterDelay: 10.0)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(popBack), userInfo: nil, repeats: false)
       
    }
    @objc func popBack()
    {
        navigationController?.popViewController(animated: true)

    }
    
    


}
