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
    func getJobs() -> Promise<[JobDTO]>
}

class JobNetworkService: BaseNetworkService {
    private let accountsPath = "Search/Jobs.json"

}

extension JobNetworkService: JobNetworkServiceProtocol {
    func getJobs() -> Promise<[JobDTO]> {
        return self.request(method: .get, path: self.accountsPath, parameters: nil)        
    }
}
