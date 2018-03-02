//
//  Book.swift
//  Library
//
//  Created by Vikram Ramkumar on 2/28/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import Foundation

class Book: NSObject {
    
    static let ID_DICT_KEY = "id"
    static let TITLE_DICT_KEY = "title"
    static let AUTHOR_DICT_KEY = "author"
    static let PUBLISHER_DICT_KEY = "publisher"
    static let CATEGORIES_DICT_KEY = "categories"
    static let LAST_CO_DICT_KEY = "lastCheckedOut"
    static let LAST_CO_BY_DICT_KEY = "lastCheckedOutBy"
    
    var id: Int?
    var title: String?
    var author: String?
    var publisher: String?
    var categories: String?
    var lastCheckOut: Date?
    var lastCheckOutBy: String?
    
    init(id: Int?, author: String, categories: String, lastCheckOut: Date?, lastCheckOutBy: String?, publisher: String, title: String) {
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
