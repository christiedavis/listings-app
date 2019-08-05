//
//  JobDTO.swift
//  ListingsApp
//
//  Created by Christie Davis on 4/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

enum JobType: String, Codable {
    case fulltime = "FT"
    case parttime = "PT"

}

struct JobDTO: Codable {
    var listingId: Int?
    var title: String?
    var body: String?
    var jobLocation: String?
    var jobType: JobType?
    var company: String?

    var instructions: String?
    var applicationDetails: JobApplicationDetailsDTO?
    
    enum CodingKeys: String, CodingKey {

        case listingId = "ListingId"
        case title = "Title"
        case jobType = "JobType"
        case jobLocation = "JobLocation"
        case company = "Company"
        case body = "Body"
        case instructions = "Instructions"
        case applicationDetails = "JobApplicationDetails"

        

    }
}
