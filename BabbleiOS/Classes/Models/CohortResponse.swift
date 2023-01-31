//
//  File.swift
//  
//
//  Created by iMac on 30/01/23.
//

import Foundation

struct CohortResonseElement: Codable {
    let document: CohortDocument?
    let readTime: String?
}

// MARK: - Document
struct CohortDocument: Codable {
    let name: String?
    let fields: CohortFields?
    let createTime, updateTime: String?
}

// MARK: - Fields
struct CohortFields: Codable {
    let userID: StringValue?
    let customerIDS: CohortCustomerIDS?
    let name, createdOn, updatedOn, source: StringValue?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case customerIDS = "customer_ids"
        case name
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case source
    }
}

// MARK: - CustomerIDS
struct CohortCustomerIDS: Codable {
    let arrayValue: CohortArrayValue?
}

// MARK: - ArrayValue
struct CohortArrayValue: Codable {
    let values: [StringValue]?
}

typealias CohortResonse = [CohortResonseElement]
