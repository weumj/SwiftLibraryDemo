//
//  BookDetailViewController.swift
//  SwiftLibrary
//
//  Created by mj on 2016. 5. 29..
//  Copyright © 2016년 mj. All rights reserved.
//

import UIKit
import SafariServices

class BookDetailViewController: UIViewController {

    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelPublishDate: UILabel!
    @IBOutlet weak var textDesc: UITextView!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var btnViewInfo: UIButton!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = self.book {
            initViewWithBook(book)
        } else {
            self.showAlertViewController("Couldn't find book data")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func onClickCancel(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClicViewInfo(_ sender: AnyObject){
        guard
            let nsUrl = URL(string: book!.descUrl!)
            else {
                fatalError("Couldn't parse url to NSURL: \(book!.descUrl)")
        }
        
        
        let svc = SFSafariViewController(url: nsUrl)
        self.present(svc, animated: true, completion: nil)
    }
    
    fileprivate func initViewWithBook(_ book: Book){

        if let url = URL(string: book.imageURi!), let data = try? Data(contentsOf: url) {
            imageThumb.image = UIImage(data: data)
        }
                
        labelTitle.text = book.title
        labelAuthor.text = book.author
        labelPublishDate.text = book.publishDate
                
        textDesc.text = book.desc
        
        
        btnViewInfo.isEnabled = book.descUrl != nil
        
    }
    
}
