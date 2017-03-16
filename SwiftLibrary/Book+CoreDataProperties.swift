//
//  Book+CoreDataProperties.swift
//  SwiftLibrary
//
//  Created by mj on 2016. 5. 21..
//  Copyright © 2016년 mj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var title: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var imageURi: String?
    @NSManaged var id: String?
    @NSManaged var descUrl: String?
    @NSManaged var desc: String?
    @NSManaged var author: String?
    @NSManaged var publishDate: String?

}
