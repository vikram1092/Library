//
//  AddBookController.swift
//  Library
//
//  Created by Vikram Ramkumar on 3/1/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import Foundation
import UIKit

class AddBookController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = CGFloat(8)
        submitButton.clipsToBounds = true
    }
    
    @IBAction func onSubmit(_ sender: Any) {
    }
}
