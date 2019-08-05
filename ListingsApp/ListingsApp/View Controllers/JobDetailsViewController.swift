//
//  JobDetailsViewController.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol JobDetailsViewProtocol {
}

class JobDetailsViewController: UIViewController {

    let presenter = JobDetailPresenter()
    
    @IBOutlet var screenTitleLabel: UILabel!
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var complanyLable: UILabel!
    @IBOutlet var listingLabel: UILabel!
    @IBOutlet var listingLocationLabel: UILabel!
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var instructionsLabel: UILabel!
    
    @IBOutlet var contactNameLAbel: UILabel!
    @IBOutlet var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.load()
        self.setup()
    }
    
    private func setup() {
        self.screenTitleLabel.text = self.presenter.screenTitle
        
        if let job = self.presenter.jobDisplay {
            self.jobTitleLabel.text = job.title
            if let listingID = job.listingId {
                self.listingLabel.text = "\(listingID)"
            } else {
                self.listingLabel.text = nil
            }
            self.listingLocationLabel.text = job.jobLocation
            self.complanyLable.text = job.company
            self.typeLabel.text = job.jobType?.toDisplayString()
            self.bodyLabel.text = job.body
            self.instructionsLabel.text = job.instructions
            if let contactName = job.applicationDetails?.contactName {
                self.contactNameLAbel.text = "Apply with: \(contactName)"
            }
        }
    }
    
    @IBAction func applyTapped(_ sender: Any) {
        self.presenter.applyTapped()
    }
}

extension JobDetailsViewController: JobDetailsViewProtocol {
    
}
