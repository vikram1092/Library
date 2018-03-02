//
//  LibraryManager.swift
//  Library
//
//  Created by Vikram Ramkumar on 2/28/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import Foundation


class LibraryManager {
    
    static let REFRESH_NOTIFICATION = Notification.Name("LibraryManagerRefreshed")
    private let libraryUrl = "https://ivy-ios-challenge.herokuapp.com/"
    var books: [Book] = []
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return books.count
    }
    
    func itemFor(index: Int) -> Book? {
        
        return books[index]
    }
    
    func refreshData() {
        
        //Send URL request to library URL to get books from library
        let urlString = libraryUrl + "books"
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }
            else if let data = data {
                do {
                    //Convert data into JSON dictionary
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    //Loop through and add books
                    if let bookDict = json as? [NSDictionary] {
                        
                        self.books = []
                        for bookObj in bookDict {
                            //Create Book object
                            let book = Book()
                            book.title = bookObj[Book.TITLE_DICT_KEY] as? String
                            book.author = bookObj[Book.AUTHOR_DICT_KEY] as? String
                            book.publisher = bookObj[Book.PUBLISHER_DICT_KEY] as? String
                            book.categories = bookObj[Book.CATEGORIES_DICT_KEY] as? String
                            book.lastCheckOutBy = bookObj[Book.LAST_CO_BY_DICT_KEY] as? String
                            
                            //Convert date string to date
                            if let dateString = bookObj[Book.LAST_CO_DICT_KEY] as? String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
                                let date = dateFormatter.date(from: dateString)
                                book.lastCheckOut = date
                            }
                            
                            //Add book to library books
                            self.books.append(book)
                        }
                    }
                    
                    //Notify any receivers that data has finished loading
                    NotificationCenter.default.post(name: LibraryManager.REFRESH_NOTIFICATION, object: nil)
                }
                catch let jsonErr as NSError { print(jsonErr) }
            }
        }
        
        task.resume()
    }
}
