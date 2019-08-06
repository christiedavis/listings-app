//
//  NetworkService.swift
//  ListingsApp
//
//  Created by Christie Davis on 4/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import Foundation
import PromiseKit

protocol JobNetworkServiceProtocol: class {
    func getJobs() -> Promise<JobCollectionDTO>
}

class JobNetworkService: BaseNetworkService {
    private let accountsPath = "Search/Jobs.json"
}

extension JobNetworkService: JobNetworkServiceProtocol {
    func getJobs() -> Promise<JobCollectionDTO> {
        return self.request(method: .get, path: self.accountsPath, parameters: nil)        
    }
}
