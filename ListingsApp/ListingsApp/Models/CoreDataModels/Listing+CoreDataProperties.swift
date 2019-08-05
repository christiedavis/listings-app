//
//  Listing+CoreDataProperties.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//
//

import Foundation
import CoreData


extension Listing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Listing> {
        return NSFetchRequest<Listing>(entityName: "Listing")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var title: String?
    @NSManaged public var jobType: String?
    @NSManaged public var body: String?
    @NSManaged public var location: String?
    @NSManaged public var company: String?
    @NSManaged public var instructions: String?
    @NSManaged public var has: ListingProperties?

}
