//
//  ViewController.swift
//  SwiftLibrary
//
//  Created by mj on 2016. 5. 21..
//  Copyright © 2016년 mj. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        //fetchRequest.predicate = NSPredicate(format: "author == %", "Jhon Doe")
        
        do{
          try books = manageObjectContext.fetch(fetchRequest) as! [Book]
        } catch let error as NSError {
            self.showAlertViewController("Couldn't load library data")
            print("Couldn't fetch \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentBookDetail" {
            let navigationController = segue.destination as! UINavigationController
            let bookDetailViewController = navigationController.topViewController as! BookDetailViewController
            
            if let selectedBookCell = sender as? BookTableViewCell {
                let indexPath = tableView.indexPath(for: selectedBookCell)!
                let selectedBook = books[indexPath.row]
                bookDetailViewController.book = selectedBook
            }
        }
    }

}


// table view
extension LibraryViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BookTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookTableViewCell
        
        let book = books[indexPath.row]
        
        cell.labelTitle.text = book.title
        cell.labelAuthor.text = book.author
        
        if let url = URL(string: book.imageURi!), let data = try? Data(contentsOf: url){
            cell.imageThumb.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            manageObjectContext.delete(books[indexPath.row])
            books.remove(at: indexPath.row)
            
            do {
                try manageObjectContext.save()
            } catch let error as NSError {
                showAlertViewController("Couldn't sabe object")
                print("Couldn't save \(error), \(error.userInfo)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        default:
            return
        }
    }
    
}

