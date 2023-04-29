//
//  File.swift
//  
//
//  Created by iMac on 31/01/23.
//

import Foundation
struct EligibleSurveyRequest: Codable {
    let babbleUserId, customerId: String?
    
    enum CodingKeys: String, CodingKey {
        case babbleUserId = "babble_user_id"
        case customerId = "customer_id"
    }
}

struct SurveyCloseRequest: Codable {
    let surveyInstanceId: String?
    
    enum CodingKeys: String, CodingKey {
        case surveyInstanceId = "survey_instance_id"
    }
}

