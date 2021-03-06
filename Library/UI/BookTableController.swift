//
//  BookTableController.swift
//  Library
//
//  Created by Vikram Ramkumar on 2/28/18.
//  Copyright © 2018 Vikram Ramkumar. All rights reserved.
//

import UIKit

class BookTableController: UITableViewController {

    static let TABLE_TO_DETAIL_SEGUE = "BookTableToBookDetailSegue"
    static let TABLE_TO_ADD_BOOK_SEGUE = "BookTableToAddBookSegue"
    let dataManager = LibraryManager.shared
    var selectedBook: Book? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.backgroundColor = tableView.backgroundColor
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: LibraryManager.REFRESH_NOTIFICATION, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    
    @objc func refreshData() {
        dataManager.refreshData()
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onAddBook(_ sender: Any) {
        performSegue(withIdentifier: BookTableController.TABLE_TO_ADD_BOOK_SEGUE, sender: nil)
    }
    
    @IBAction func onMore(_ sender: Any) {
       
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAllOption = UIAlertAction(title: "Delete All Books", style: .destructive) { (action) in
            
            let confirmAlert = UIAlertController(title: "Are you sure?", message: "This action cannot be undone.", preferredStyle: .alert)
            let confirmDeleteOption = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                self.dataManager.deleteAllBooks()
            }
            let cancelConfirmOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            confirmAlert.addAction(confirmDeleteOption)
            confirmAlert.addAction(cancelConfirmOption)
            self.present(confirmAlert, animated: true, completion: nil)
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(deleteAllOption)
        alert.addAction(cancelOption)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfItemsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as! BookCell
        guard let book = dataManager.itemFor(index: indexPath.row) else { return cell }
        
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let book = dataManager.itemFor(index: indexPath.row) else { return }
        selectedBook = book
        performSegue(withIdentifier: BookTableController.TABLE_TO_DETAIL_SEGUE, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BookTableController.TABLE_TO_DETAIL_SEGUE, let vc = segue.destination as? BookDetailController {
            
            vc.book = self.selectedBook
        }
    }
}



