//
//  DataService.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol DataServiceProtocol: class {
    func getJobs() -> [JobDTO]
    func updateJobs(_ jobList: [JobDTO]?)
}

class DataService {

}

extension DataService: DataServiceProtocol {
    func getJobs() -> [JobDTO] {
        let jobs: [Listing]? = Listing.lookup()
        let dtoArray = jobs?.map({ $0.dto() })
        return dtoArray ?? []
    }
    
    
    func updateJobs(_ jobList: [JobDTO]?) {
        jobList?.forEach { (jobDto) in
            if let existingJob: Listing = Listing.lookup(byIdentifier: jobDto.identifier) {
                existingJob.update(fromDTO: jobDto)
            } else {
                _ = Listing.newObject(jobDto: jobDto)
            }
        }
        PersistenceHelper.shared().saveContext()
    }
}

