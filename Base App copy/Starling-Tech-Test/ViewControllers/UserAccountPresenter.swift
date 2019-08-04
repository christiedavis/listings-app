//
//  UserAccountPresenter.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
import PromiseKit

protocol UserAccountPresenterProcotocol {
    
}

class UserAccountPresenter: BasePresenter {

    weak var view: UserAccountViewController?
    weak var coordinator: AppCoordinatorDelegate?
    
    var bankAccountList: [BankAccountDTO] = []
   
}

extension UserAccountPresenter: UserAccountPresenterProcotocol {
    func load() {
        _ = serviceFactory.getUserAccounts()
            .done { [weak self] (bankAccountList) in
                self?.bankAccountList = bankAccountList.accounts ?? []
        }
        .catch { (error) in
            print(error)
        }
        
    }
}
