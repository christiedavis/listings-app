//
//  ListingProperties+CoreDataProperties.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//
//

import Foundation
import CoreData


extension ListingProperties {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListingProperties> {
        return NSFetchRequest<ListingProperties>(entityName: "ListingProperties")
    }

    @NSManaged public var applicationType: NSNumber?
    @NSManaged public var contactName: String?
    @NSManaged public var identifier: String?
    @NSManaged public var website: String?
    @NSManaged public var belongsTo: Listing?

}
