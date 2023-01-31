//
//  File.swift
//  
//
//  Created by iMac on 30/01/23.
//

import Foundation

struct BackendEventResponseElement: Codable {
    let document: BackendEventDocument?
    let readTime: String?
}

// MARK: - Document
struct BackendEventDocument: Codable {
    let name: String?
    let fields: BackendEvent?
    let createTime, updateTime: String?
}

// MARK: - DocumentFields
struct BackendEvent: Codable {
    let createdAt, surveyInstanceID: StringValue?
    let properties: BackendEventProperties?
    let customerID, eventName, userID: StringValue?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case surveyInstanceID = "survey_instance_id"
        case properties
        case customerID = "customer_id"
        case eventName = "event_name"
        case userID = "user_id"
    }
}
// MARK: - Properties
struct BackendEventProperties: Codable {
    let mapValue: BackendEventMapValue?
}

// MARK: - MapValue
struct BackendEventMapValue: Codable {
    let fields: BackendEventMapValueFields?
}

// MARK: - MapValueFields
struct BackendEventMapValueFields: Codable {
    let orderID: StringValue?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
    }
}

typealias BackendEventResponse = [BackendEventResponseElement]
