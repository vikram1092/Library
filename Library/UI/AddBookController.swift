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
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var categoriesField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = CGFloat(8)
        submitButton.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf), name: LibraryManager.BOOK_ADDED_NOTIFICATION, object: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        guard let title = titleField.text, let author = authorField.text, title != "", author != "" else {
            //Show error
            let alert = UIAlertController(title: "Incomplete Information", message: "The book needs its title and author.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let publisher = publisherField.text
        let categories = categoriesField.text
        
        let book = Book()
        book.title = title
        book.author = author
        book.publisher = publisher
        book.categories = categories
        LibraryManager.shared.addBookToLibrary(book: book)
    }
    
    @IBAction func onDone() {
        
        guard titleField.text == nil || titleField.text == "",
            authorField.text == nil || authorField.text == "",
            publisherField.text == nil || publisherField.text == "",
            categoriesField.text == nil || categoriesField.text == "" else {

            //Show error
            let alert = UIAlertController(title: "Are you sure?", message: "Your progress will be lost.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Leave", style: .destructive, handler: { (action) in
                self.dismissSelf()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        dismissSelf()
    }
    
    @objc func dismissSelf() {
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
