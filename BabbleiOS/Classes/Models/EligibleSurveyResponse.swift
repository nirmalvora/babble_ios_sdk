//
//  File.swift
//  
//
//  Created by iMac on 31/01/23.
//

import Foundation

struct EligibleSurveyResponse: Codable {
    let eligibleSurveyIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case eligibleSurveyIDS = "eligible_survey_ids"
    }
}
