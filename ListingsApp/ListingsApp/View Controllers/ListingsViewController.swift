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
    func reloadView()
    
    func showLoading()
    func hideLoading()
    func showError(_ errorMessage: String)
    func hideError()
}

class ListingsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var errorButton: UIButton!
    @IBOutlet var errorView: UIView!
    
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    let presenter = ListingsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.load()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = "Latest Jobs Available" // TODO: strings should be localized
        
        self.tableView.register(UINib(nibName: ListingTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: ListingTableViewCell.reuseIdentifier())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    @IBAction func errorTapped(_ sender: Any) {
        self.hideError()
        self.presenter.load()
    }
}

extension ListingsViewController: ListingsViewProtocol {
    func reloadView() {
        tableView.reloadData()
    }
    
    func showLoading() {
        self.loadingView.isHidden = false
    }
    
    func hideLoading() {
        self.loadingView.isHidden = true
    }
    
    func showError(_ errorMessage: String) {
        self.errorView.isHidden = false
        self.errorLabel.text = errorMessage
    }
    
    func hideError() {
        self.errorView.isHidden = true
    }

}

extension ListingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListingTableViewCell.reuseIdentifier()) as? ListingTableViewCell {
            cell.setup(self.presenter.jobForRow(indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectRow(indexPath.row)
    }
}
