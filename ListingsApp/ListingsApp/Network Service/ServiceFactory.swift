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
    func getUserAccounts() -> Promise<BankAccountCollectionDTO>
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
        self.networkService = AccountNetworkService()
    }
    
    var networkService: AccountNetworkServiceProtocol
}

extension ServiceFactory: ServiceFactoryProtocol {
    func getUserAccounts() -> Promise<BankAccountCollectionDTO> {
        return self.networkService.getUserAccounts()
    }
}
