//
//  ListingProperties+CoreDataClass.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//
//

import Foundation
import CoreData


public class ListingProperties: NSManagedObject {
    class func newObject(jobDto: JobDTO) -> ListingProperties {
        let persistenceHelper = PersistenceHelper.shared()
        
        let newListingDetails = ListingProperties(context: persistenceHelper.managedObjectContext())
        populateListingDetails(newListingDetails, fromDTO: jobDto)
        return newListingDetails
    }
    
    func update(fromDTO jobDto: JobDTO) {
        ListingProperties.populateListingDetails(self, fromDTO: jobDto)
    }
    
    func dto() -> JobApplicationDetailsDTO {
        return JobApplicationDetailsDTO(applicationType: self.applicationType as? Int, contactName: self.contactName, website: self.website)
    }
    
    private class func populateListingDetails(_ details: ListingProperties, fromDTO jobDto: JobDTO) {
        details.identifier = "\(jobDto.listingId ?? 0)"
        details.applicationType = jobDto.applicationDetails?.applicationType as NSNumber?
        details.website = jobDto.applicationDetails?.website
        details.contactName = jobDto.applicationDetails?.contactName
    }
}
