//
//  Listing+CoreDataClass.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Listing)
public class Listing: NSManagedObject {
    class func newObject(jobDto: JobDTO) -> Listing {
        let persistenceHelper = PersistenceHelper.shared()
        
        let newListing = Listing(context: persistenceHelper.managedObjectContext())
        populateListing(newListing, fromDTO: jobDto)
        return newListing
    }
    
    func update(fromDTO jobDTO: JobDTO) {
        Listing.populateListing(self, fromDTO: jobDTO)
    }
    
    func dto() -> JobDTO {
        
        guard let listingID = Int(self.identifier ?? "") else {
            fatalError("required properties don't exist")
        }
        
        let jobTypeEnum: JobType? = JobType(rawValue: self.jobType ?? "")
        let details = self.has?.dto()
        
        return JobDTO(listingId: listingID,
                      title: self.title,
                      body: self.body,
                      jobLocation: self.location,
                      jobType: jobTypeEnum,
                      company: self.company,
                      instructions: self.instructions,
                      applicationDetails: details)
    }
    
    private class func populateListing(_ listing: Listing, fromDTO jobDTO: JobDTO) {
        listing.identifier = jobDTO.identifier
        listing.title = jobDTO.title
        listing.jobType = jobDTO.jobType?.rawValue
        listing.body = jobDTO.body
        listing.location = jobDTO.jobLocation
        listing.company = jobDTO.company
        listing.instructions = jobDTO.instructions
        
        // add listing properties
        if let listingsProperty = listing.has {
            listingsProperty.update(fromDTO: jobDTO)
        } else {
            let properties = ListingProperties.newObject(jobDto: jobDTO)
            listing.has = properties
            properties.belongsTo = listing
        }
    }
}
