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
    static let BOOK_UPDATED_NOTIFICATION = Notification.Name("LibraryManagerRefreshed")
    static let BOOK_DELETED_NOTIFICATION = Notification.Name("LibraryManagerRefreshed")
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
                    if response.statusCode / 100 != 2 {
                        
                    }
                }
                
                //Notify any receivers that book has been added
                NotificationCenter.default.post(name: LibraryManager.BOOK_ADDED_NOTIFICATION, object: nil)
            }
            
            task.resume()
        }
        catch let error as NSError {
            //Show error here
            print(error as Any)
        }
    }
    
    func updateBook(id: Int, dictionary: NSDictionary) {
        
        do {
            //Get payload
            print(dictionary)
            let objData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            
            //Send URL request to library URL to update book in library
            let urlString = libraryUrl + "books/" + String(describing: id)
            guard let url = URL(string: urlString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = objData
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                }
                else if let response = response as? HTTPURLResponse {
                    print("response received \(response.statusCode)")
                    if response.statusCode / 100 != 2 {
                        
                    }
                }
                
                guard let data = data else { return }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    //Notify any receivers that book has finished updating
                    NotificationCenter.default.post(name: LibraryManager.BOOK_UPDATED_NOTIFICATION, object: jsonObject)
                }
                catch let error as NSError {
                    //Show error here
                    print(error as Any)
                }
            }
            
            task.resume()
        }
        catch let error as NSError {
            //Show error here
            print(error as Any)
        }
    }
    
    func deleteBook(id: Int) {
    
        //Send URL request to library URL to delete book from library
        let urlString = libraryUrl + "books/" + String(describing: id)
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }
            else if let response = response as? HTTPURLResponse {
                print("response received \(response.statusCode)")
                if response.statusCode / 100 != 2 {
                    
                }
            }
            
            //Notify any receivers that book has finished being deleted
            NotificationCenter.default.post(name: LibraryManager.BOOK_DELETED_NOTIFICATION, object: nil)
        }
        
        task.resume()
    }
    
    
    func deleteAllBooks() {
        
        //Send URL request to delete
        let urlString = libraryUrl + "clean"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }
            else if let response = response as? HTTPURLResponse {
                print("response received \(response.statusCode)")
                if response.statusCode / 100 != 2 {
                    
                }
                
                //Delete all books locally
                self.books = []
            }
            
            //Notify any receivers that data has finished being deleted
            NotificationCenter.default.post(name: LibraryManager.REFRESH_NOTIFICATION, object: nil)
        }
        
        task.resume()
    }
    
    func convertDictToBook(dict: NSDictionary) -> Book {
        
        //Create Book object
        let book = Book()
        book.id = dict[Book.ID_DICT_KEY] as? Int
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
        dictionary.setValue(book.id, forKey: Book.ID_DICT_KEY)
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
