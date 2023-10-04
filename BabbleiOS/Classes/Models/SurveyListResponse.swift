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
//   let surveyResponse = try? JSONDecoder().decode(SurveyResponse.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let surveyResponse = try? JSONDecoder().decode(SurveyResponse.self, from: jsonData)

import Foundation

// MARK: - SurveyResponse
struct SurveyResponseElement: Codable {
    let document: Document?
    let readTime: String?
}

// MARK: - Document
struct Document: Codable {
    let name: String?
    let fields: Fields?
    let createTime, updateTime: String?
}

// MARK: - Fields
struct Fields: Codable {
    let title, status, maxResponses, endDate, eventName, cohortId, relevancePeriod: StringValue?
    let userID, createdAt, triggerID, startDate: StringValue?
    let updatedAt: StringValue?
    let samplingPercentage, triggerDelay: IntegerValue?
    let isQuiz: BooleanValue?

    enum CodingKeys: String, CodingKey {
        case title, status
        case maxResponses = "max_responses"
        case endDate = "end_date"
        case userID = "user_id"
        case createdAt = "created_at"
        case triggerID = "trigger_id"
        case startDate = "start_date"
        case updatedAt = "updated_at"
        case eventName = "event_name"
        case cohortId = "cohort_id"
        case relevancePeriod = "relevance_period"
        case samplingPercentage = "sampling_percentage"
        case triggerDelay = "trigger_delay"
        case isQuiz = "is_quiz"
    }
}

// MARK: - CreatedAt
struct StringValue: Codable {
    let stringValue: String?
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intValue = try? container.decode(Int.self, forKey: .stringValue) {
           stringValue = String(intValue)
       } else if let stringValue = try? container.decode(String.self, forKey: .stringValue) {
           self.stringValue = stringValue
       } else if container.contains(.stringValue) {
           stringValue = nil
       } else {
           throw DecodingError.keyNotFound(CodingKeys.stringValue, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Key not found"))
       }
    }
}

typealias SurveyResponse = [SurveyResponseElement]
