//
//  ServiceFactort.swift
//  ListingsApp
//
//  Created by Christie Davis on 4/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import Foundation
import PromiseKit

protocol ServiceFactoryProtocol {
    func getJobs() -> Promise<JobCollectionDTO>
}

class ServiceFactory {
    private static var sharedInstance: ServiceFactoryProtocol?
    public static var shared: ServiceFactoryProtocol {
        if let instance = sharedInstance {
            return instance
        }
        let instance = ServiceFactory()
        sharedInstance = instance
        return instance
    }
    
    init() {
        self.networkService = JobNetworkService()
        self.dataService = DataService()
    }
    
    var networkService: JobNetworkServiceProtocol
    var dataService: DataServiceProtocol
}

extension ServiceFactory: ServiceFactoryProtocol {
    func getJobs() -> Promise<JobCollectionDTO> {
        return self.networkService.getJobs()
            .recover { (error) -> Guarantee<JobCollectionDTO> in
                let cachedJobs = self.dataService.getJobs()
                if cachedJobs.isEmpty {
                    // if there is no cache - throw the error to display
                    throw error
                }
                return Guarantee.value(JobCollectionDTO(jobsList: cachedJobs))
            }
            .then { (collection) -> Promise<JobCollectionDTO> in
                self.dataService.updateJobs(collection.list)
                return Promise.value(collection)
            }
    }
}
