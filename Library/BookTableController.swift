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
    let dataManager = LibraryManager()
    var selectedBook: Book? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: LibraryManager.REFRESH_NOTIFICATION, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    
    func refreshData() {
        dataManager.refreshData()
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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



