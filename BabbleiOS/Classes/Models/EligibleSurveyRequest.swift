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
