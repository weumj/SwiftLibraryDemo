//
//  Utils.swift
//  SwiftLibrary
//
//  Created by mj on 2016. 5. 22..
//  Copyright © 2016년 mj. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Utils {
    
}

extension Utils {
    static func jsonToDict(_ src: NSString)-> NSDictionary?{
        let data = src.data(using: String.Encoding.utf8.rawValue)
        
        do {
            return try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary
        } catch let error as NSError {
            print("JSON Error \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension String {
    func replace(_ string : String, replacement : String) -> String {
        return replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return replace(" ", replacement: "")
    }
}

extension UIViewController {
    var manageObjectContext : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    }
    
    func saveManagedObjectContext() {
        do {
            try manageObjectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            showAlertViewController("Could not save object")
        }
    }
    
    func showAlertViewController(_ message : String){
        let alertController = UIAlertController(title : "Library", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
