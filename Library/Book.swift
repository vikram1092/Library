//
//  Book.swift
//  Library
//
//  Created by Vikram Ramkumar on 2/28/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import Foundation

class Book: NSObject {
    
    var id: Int?
    var author: String?
    var categories: String?
    var lastCheckOut: NSDate?
    var lastCheckOutBy: String?
    var publisher: String?
    var title: String?
    
    init(id: Int?, author: String, categories: String, lastCheckOut: NSDate?, lastCheckOutBy: String?, publisher: String, title: String) {
        self.id = id
        self.author = author
        self.lastCheckOut = lastCheckOut
        self.lastCheckOutBy = lastCheckOutBy
        self.publisher = publisher
        self.title = title
    }
    
    override init() {
        self.id = nil
        self.author = nil
        self.lastCheckOut = nil
        self.lastCheckOutBy = nil
        self.publisher = nil
        self.title = nil
    }
}

