//
//  File.swift
//  
//
//  Created by iMac on 31/01/23.
//

import Foundation
struct AddResponseRequest: Codable {
    let surveyId, surveyInstanceId, questionText, responseCreateAt, responseUpdateAt, response: String?
    
    let questionTypeId, sequenceNo: Int?
    
    let shouldMarkComplete, shouldMarkPartial: Bool?
    
    enum CodingKeys: String, CodingKey {
        case surveyId = "survey_id"
        case questionTypeId = "question_type_id"
        case sequenceNo = "sequence_no"
        case surveyInstanceId = "survey_instance_id"
        case questionText = "question_text"
        case responseCreateAt = "response_created_at"
        case responseUpdateAt = "response_updated_at"
        case shouldMarkComplete = "should_mark_complete"
        case shouldMarkPartial = "should_mark_partial"
        case response = "response"
    }
}
