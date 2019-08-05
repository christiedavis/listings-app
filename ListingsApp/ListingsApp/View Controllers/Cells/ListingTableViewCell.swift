//
//  ListingTableViewCell.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {

    @IBOutlet var titleLable: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    static func reuseIdentifier() -> String {
        return "ListingTableViewCell"
    }
    
    func setup(_ jobDto: JobDTO?) {
        self.titleLable.text = jobDto?.title
        self.companyLabel.text = jobDto?.company
        self.locationLabel.text = jobDto?.jobLocation
    }
    
}
