//
//  ListingsViewController.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
import PromiseKit

protocol ListingsViewProtocol {
    
}

class ListingsViewController: UIViewController {
    
    let presenter = ListingsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.load()
        
    }
}

extension ListingsViewController: ListingsViewProtocol {
    
}
