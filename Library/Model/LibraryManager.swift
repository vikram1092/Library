//
//  LibraryManager.swift
//  Library
//
//  Created by Vikram Ramkumar on 2/28/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import Foundation


class LibraryManager {
    
    static let shared = LibraryManager()
    
    static let REFRESH_NOTIFICATION = Notification.Name("LibraryManagerRefreshed")
    static let BOOK_ADDED_NOTIFICATION = Notification.Name("LibraryManagerRefreshed")
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
                    if let dictArray = json as? [NSDictionary] {
                        
                        //Add books to library books
                        self.books = []
                        for bookDict in dictArray {
                            self.books.append(self.convertDictToBook(dict: bookDict))
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
    
    func addBookToLibrary(book: Book) {
        
        do {
            //Get payload
            let bookDict = convertBookToDict(book: book)
            let data = try JSONSerialization.data(withJSONObject: bookDict, options: [])
            
            //Send URL request to library URL to add book to library
            let urlString = libraryUrl + "books"
            guard let url = URL(string: urlString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession.shared
            let task = session.uploadTask(with: urlRequest, from: data) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                }
                else if let response = response as? HTTPURLResponse {
                    print("response received \(response.statusCode)")
                }
                
                //Notify any receivers that data has finished loading
                NotificationCenter.default.post(name: LibraryManager.BOOK_ADDED_NOTIFICATION, object: nil)
            }
            
            task.resume()
        }
        catch let error as NSError {
            //Show error here
            print(error as Any)
        }
    }
    
    func convertDictToBook(dict: NSDictionary) -> Book {
        
        //Create Book object
        let book = Book()
        book.title = dict[Book.TITLE_DICT_KEY] as? String
        book.author = dict[Book.AUTHOR_DICT_KEY] as? String
        book.publisher = dict[Book.PUBLISHER_DICT_KEY] as? String
        book.categories = dict[Book.CATEGORIES_DICT_KEY] as? String
        book.lastCheckOutBy = dict[Book.LAST_CO_BY_DICT_KEY] as? String
        
        //Convert date string to date
        if let dateString = dict[Book.LAST_CO_DICT_KEY] as? String {
            book.lastCheckOut = self.stringToDate(dateString: dateString)
        }
        
        return book
    }
    
    func convertBookToDict(book: Book) -> NSDictionary {
        
        //Get NSDictionary from Book object
        let dictionary = NSMutableDictionary()
        dictionary.setValue(book.title, forKey: Book.TITLE_DICT_KEY)
        dictionary.setValue(book.author, forKey: Book.AUTHOR_DICT_KEY)
        dictionary.setValue(book.publisher, forKey: Book.PUBLISHER_DICT_KEY)
        dictionary.setValue(book.lastCheckOutBy, forKey: Book.LAST_CO_BY_DICT_KEY)
        dictionary.setValue(dateToString(date: book.lastCheckOut), forKey: Book.LAST_CO_DICT_KEY)
        
        return dictionary
    }
    
    func stringToDate(dateString: String) -> Date? {
        //Get date from date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.date(from: dateString)
    }
    
    func dateToString(date: Date?) -> String? {
        //Get date string from date
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.string(from: date)
    }
}
