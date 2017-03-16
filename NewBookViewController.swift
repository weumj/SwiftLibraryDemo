//
//  NewBookViewController.swift
//  SwiftLibrary
//
//  Created by mj on 2016. 5. 22..
//  Copyright © 2016년 mj. All rights reserved.
//

import UIKit
import CoreData

class NewBookViewController: UIViewController {
    
    @IBOutlet weak var textISBN : UITextField!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelPublishDate: UILabel!
    @IBOutlet weak var textDesc: UITextView!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewDetails: UIView!
    
    
    var processedBook : Book?
    let progressHUD = ProgressHUD(text: "Pulling data")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDetails.isHidden = true
        btnAdd.isEnabled = false
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }
    
   
    @IBAction func onClickAdd(_ sender: AnyObject){
        if processedBook != nil {
            saveManagedObjectContext()
            showAlertViewController("Book successfully added")
        } else {
            showAlertViewController("Book was emtpy")
        }
    }
    
    
    @IBAction func onClickSearch(_ sender: AnyObject){
        guard
            let isbn = textISBN.text,
            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let apiUri = dict["Google Books Search ISBN"] as? String
        else {
            self.showAlertViewController("Counldn't create search URI from isbn code")
            return
        }
        
        showProgress()
        
        Utils.getBookFromNetwork(apiUri + isbn, managedObjectContext: self.manageObjectContext, action: {
            (book:Book) in
            
                self.loadBookDetails(book)
                self.btnAdd.isEnabled = true
                self.viewDetails.isHidden = false
            
                self.hideProgress()
                
            }, error1: {
                self.btnAdd.isEnabled = true
                if self.processedBook != nil {
                    self.viewDetails.isHidden = false
                }
                
                self.hideProgress()

                self.showAlertViewController($0)
                
            }
        )
        
    }
 
}

private extension NewBookViewController {
    func showProgress(){
        progressHUD.show()
        textISBN.isUserInteractionEnabled = false
        textISBN.alpha = 0.3
        btnSearch.isUserInteractionEnabled = false
        btnSearch.alpha = 0.3
    }
    
    func hideProgress(){
        progressHUD.hide()
        textISBN.isUserInteractionEnabled = true
        textISBN.alpha = 1.0
        btnSearch.isUserInteractionEnabled = true
        btnSearch.alpha = 1.0
    }
    
    func loadBookDetails(_ book: Book){
        if let url = URL(string: book.imageURi!), let data = try? Data(contentsOf: url) {
            imageThumb.image = UIImage(data: data)
        }
        
        labelTitle.text = book.title
        labelAuthor.text = book.author
        labelPublishDate.text = book.publishDate
        
        textDesc.text = book.desc
        
        processedBook = book
    }
    
    
    
}

private extension Utils {
    static func getBookFromNetwork(_ url: String, managedObjectContext: NSManagedObjectContext, action: @escaping (Book) -> () , error1: ((String) -> ())?) {
        let url = URL(string: url)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data: Data?, response: URLResponse?, error: NSError?) in
            
            func errorOutput(_ str:String) -> () {
                DispatchQueue.main.sync{
                    error1?(str)
                }
            }
            
            guard
                let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue),
                let dict = Utils.jsonToDict(jsonString)
                else {
                    errorOutput("Couldn't find results for code: \(url)")
                    //self.showAlertViewController("Couldn't find results for code: \(url)")
                    return
            }
            
            guard
                let items = dict["items"] as? NSArray,
                let firstItem = items[0] as? NSDictionary,
                let identifier = firstItem["id"] as? String,
                let volumeInfo = firstItem["volumeInfo"] as? NSDictionary
                else {
                    errorOutput("Couldn't process dict file")
                    return
            }
            
            let title = volumeInfo["title"] as? String ?? ""
            let description = volumeInfo["description"] as? String ?? ""
            let publishDate = volumeInfo["publishedDate"] as? String ?? ""
            let infoLink = volumeInfo["infoLink"] as? String ?? ""
            
            var smallThumbnail = ""
            if let imageLinks = volumeInfo["imageLinks"] as? NSDictionary {
                smallThumbnail = imageLinks["smallThumbnail"] as? String ?? ""
            }
            
            var mainAuthor = ""
            if let authors = volumeInfo["authors"] as? NSArray {
                mainAuthor = authors[0] as? String ?? ""
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedObjectContext)
            
            let book = Book(entity: entity!, insertInto: managedObjectContext)
            book.id = identifier
            book.title = title
            book.author = mainAuthor
            book.publishDate = publishDate
            book.desc = description
            book.descUrl = infoLink
            book.imageURi = smallThumbnail
            
            //self.processedBook = book
            //self.processedBook = Book(entity: entity!, insertIntoManagedObjectContext: self.manageObjectContext)
            
            DispatchQueue.main.sync{
                action(book)
            }
        } as! (Data?, URLResponse?, Error?) -> Void) 

        task.resume()
    }
}
