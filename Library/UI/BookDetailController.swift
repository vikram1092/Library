//
//  BookDetailController.swift
//  Library
//
//  Created by Vikram Ramkumar on 2/28/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import Foundation
import UIKit

class BookDetailController: UIViewController {
    
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView2: UIView!
    
    @IBOutlet weak var lastCOTimeLabel: UILabel!
    @IBOutlet weak var lastCONameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishersLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round corners for background views
        let cornerRadius = CGFloat(8)
        backView1.layer.cornerRadius = cornerRadius
        backView1.clipsToBounds = true
        backView2.layer.cornerRadius = cornerRadius
        backView2.clipsToBounds = true
        checkoutButton.layer.cornerRadius = cornerRadius
        checkoutButton.clipsToBounds = true
        editButton.layer.cornerRadius = cornerRadius
        editButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = cornerRadius
        deleteButton.clipsToBounds = true
        
        setBookValues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateValuesForBook), name: LibraryManager.BOOK_UPDATED_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf), name: LibraryManager.BOOK_DELETED_NOTIFICATION, object: nil)
        
        editButton.isHidden = !AppDelegate.showEditOptions
    }
        
    @objc func updateValuesForBook(notification: Notification) {
        
        guard let object = notification.object as? NSDictionary else {
            return
        }
        //Update book values in view
        self.book = LibraryManager.shared.convertDictToBook(dict: object)
        setBookValues()
    }
    
    func setBookValues() {
        
        guard let book = book else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = book.title ?? "Unknown"
            self.authorLabel.text = book.author ?? "Unknown"
            self.tagsLabel.text = book.categories ?? "-"
            self.lastCONameLabel.text = book.lastCheckOutBy ?? "-"
            self.publishersLabel.text = book.publisher ?? "Unknown"
            
            if let checkoutTime = book.lastCheckOut {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .medium
            let dateString = dateFormatter.string(from: checkoutTime)
                self.lastCOTimeLabel.text = dateString
            }
        }
    }
    
    @objc func dismissSelf() {
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func onCheckout(_ sender: Any) {
        
        ///Checkout book
        self.editAttribute(title: "Enter Your Name", attribute: Book.LAST_CO_BY_DICT_KEY, value: nil)
    }
    
    @IBAction func onEdit(_ sender: Any) {
        
        let alert = UIAlertController(title: "What do you want to edit?", message: nil, preferredStyle: .actionSheet)
        let titleOption = UIAlertAction(title: "Title", style: .default) { (action) in
            self.editAttribute(title: "Update Book TItle", attribute: Book.TITLE_DICT_KEY, value: self.book?.title)
        }
        let authorOption = UIAlertAction(title: "Author", style: .default) { (action) in
            self.editAttribute(title: "Update Author", attribute: Book.AUTHOR_DICT_KEY, value: self.book?.author)
        }
        let publisherOption = UIAlertAction(title: "Publisher", style: .default) { (action) in
            self.editAttribute(title: "Update Publisher", attribute: Book.PUBLISHER_DICT_KEY, value: self.book?.publisher)
        }
        let categoriesOption = UIAlertAction(title: "Tags", style: .default) { (action) in
            self.editAttribute(title: "Update Categories", attribute: Book.CATEGORIES_DICT_KEY, value: self.book?.categories)
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        alert.addAction(titleOption)
        alert.addAction(authorOption)
        alert.addAction(publisherOption)
        alert.addAction(categoriesOption)
        alert.addAction(cancelOption)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editAttribute(title: String, attribute: String, value: String?) {
        
        guard let id = book?.id else { return }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = value
            textField.placeholder = attribute
        }
        let updateOption = UIAlertAction(title: "Update", style: .default) { (action) in
            
            //Get value from text field and send to update call as dictionary
            guard let value = alert.textFields?.first?.text else { return }
            var dictionary = NSMutableDictionary()
            if attribute != Book.LAST_CO_BY_DICT_KEY {
                dictionary = LibraryManager.shared.convertBookToDict(book: self.book!) as! NSMutableDictionary
            }
            dictionary.setValue(value, forKey: attribute)
            LibraryManager.shared.updateBook(id: id, dictionary: dictionary)
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        alert.addAction(updateOption)
        alert.addAction(cancelOption)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onDelete(_ sender: Any) {
        
        guard let id = book?.id else { return }
        LibraryManager.shared.deleteBook(id: id)
    }
    
    @IBAction func onShare(_ sender: UIButton) {
        
        let activityController = UIActivityViewController(activityItems: ["Check out \(book?.title ?? "this book") by \(book?.author ?? "a great author") on my app, Library!"], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        self.present(activityController, animated: true, completion: nil)
    }
}
