//
//  File.swift
//  
//
//  Created by iMac on 29/01/23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let triggerListResponse = try? JSONDecoder().decode(TriggerListResponse.self, from: jsonData)

import Foundation

// MARK: - TriggerListResponse
struct TriggerListResponseElement: Codable {
    let document: DocumentTrigger?
    let readTime: String?
}

// MARK: - Document
struct DocumentTrigger: Codable {
    let name: String?
    let fields: TriggerFields?
    let createTime, updateTime: String?
}

// MARK: - Fields
struct TriggerFields: Codable {
    let userID, lastUpdatedAt, createdAt, description: StringValue?
    let name: StringValue?
    let status: StringValue?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case lastUpdatedAt = "last_updated_at"
        case createdAt = "created_at"
        case description, name, status
    }
}

// MARK: - Platform
struct Platform: Codable {
    let arrayValue: PlatFormArray?
}

// MARK: - ArrayValue
struct PlatFormArray: Codable {
    let values: [StringValue]?
}

typealias TriggerListResponse = [TriggerListResponseElement]
