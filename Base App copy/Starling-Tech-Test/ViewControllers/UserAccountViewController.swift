//
//  UserAccountViewController.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol UserAccountViewProtocol {
    
}

class UserAccountViewController: UIViewController {

    let presenter = UserAccountPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.load()
    
    }
}

extension UserAccountViewController: UserAccountViewProtocol {
    
}
