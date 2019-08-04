//
//  NetworkService.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import Foundation
import PromiseKit

protocol AccountNetworkServiceProtocol: class {
    func getUserAccounts() -> Promise<BankAccountCollectionDTO>
    func getUserTransactionFeed() -> Promise<UserTransactionFeedDTO>
}

class AccountNetworkService: BaseNetworkService {
    private let accountsPath = "/accounts"
    private var transactionFeedPath = "/feed/account/012b2ab8-d0f4-4aa3-ab8e-028fabbd228f/category/75ffc012-5854-4735-8ba5-810a2992b104"
}

extension AccountNetworkService: AccountNetworkServiceProtocol {
    func getUserAccounts() -> Promise<BankAccountCollectionDTO> {
        return self.request(method: .get, path: self.accountsPath)
    }
    
    func getUserTransactionFeed() -> Promise<UserTransactionFeedDTO> {
        return self.request(method: .get, path: self.transactionFeedPath)
    }
}
