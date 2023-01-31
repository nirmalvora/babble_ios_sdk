//
//  File.swift
//  
//
//  Created by iMac on 31/01/23.
//


import Foundation

// MARK: - QuestionListResponse
struct SurveyInstanceRequest: Codable {
    let surveyID, userID, customerID, surveyInstanceID,timeVal: String?
    let backendEventIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case surveyID = "survey_id"
        case userID = "user_id"
        case timeVal = "time_val"
        case customerID = "customer_id"
        case surveyInstanceID = "survey_instance_id"
        case backendEventIDS = "backend_event_ids"
    }
}
