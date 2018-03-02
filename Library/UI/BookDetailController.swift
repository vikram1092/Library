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
    @IBOutlet weak var backView3: UIView!
    @IBOutlet weak var backView4: UIView!
    
    @IBOutlet weak var lastCOTimeLabel: UILabel!
    @IBOutlet weak var lastCONameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishersLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round corners for background views
        let cornerRadius = CGFloat(8)
        backView1.layer.cornerRadius = cornerRadius
        backView1.clipsToBounds = true
        backView2.layer.cornerRadius = cornerRadius
        backView2.clipsToBounds = true
        backView3.layer.cornerRadius = cornerRadius
        backView3.clipsToBounds = true
        backView4.layer.cornerRadius = cornerRadius
        backView4.clipsToBounds = true
        checkoutButton.layer.cornerRadius = cornerRadius
        checkoutButton.clipsToBounds = true
        
        guard let book = book else { return }
        titleLabel.text = book.title ?? "Unknown"
        authorLabel.text = book.author ?? "Unknown"
        tagsLabel.text = book.categories ?? "Unknown"
        lastCONameLabel.text = book.lastCheckOutBy ?? "-"
        publishersLabel.text = book.publisher ?? "Unknown"
        
        if let checkoutTime = book.lastCheckOut {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .medium
            let dateString = dateFormatter.string(from: checkoutTime)
            lastCOTimeLabel.text = dateString
        }
    }
    
    
    @IBAction func onCheckout(_ sender: Any) {
        
        ///Checkout book
    }
}