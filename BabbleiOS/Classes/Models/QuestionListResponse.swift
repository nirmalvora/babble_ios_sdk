//
//  File.swift
//  
//
//  Created by iMac on 29/01/23.
//

import Foundation

struct QuestionListResponseElement: Codable {
    let document: QuestionDocument?
    let readTime: String?
}

struct QuestionDocument: Codable {
    let name: String?
    let fields: QuestionFields?
    let createTime, updateTime: String?
}

struct QuestionFields: Codable {
    let questionText: StringValue?
    let isDefault: BooleanValue?
    let answers: Answers?
    let surveyID, questionDesc, ctaText, id, maxValDescription, minValDescription: StringValue?
    let sequenceNo: IntegerValue?
    let userID: StringValue?
    let questionTypeID: IntegerValue?
    let inactive: BooleanValue?

    enum CodingKeys: String, CodingKey {
        case questionText = "question_text"
        case isDefault = "is_default"
        case answers
        case surveyID = "survey_id"
        case questionDesc = "question_desc"
        case ctaText = "cta_text"
        case maxValDescription = "max_val_description"
        case minValDescription = "min_val_description"
        case id
        case sequenceNo = "sequence_no"
        case userID = "user_id"
        case questionTypeID = "question_type_id"
        case inactive
    }
}

struct Answers: Codable {
    let arrayValue: QuestionArrayValue?
}

// MARK: - ArrayValue
struct QuestionArrayValue: Codable {
    let values: [StringValue]?
}

// MARK: - Inactive
struct BooleanValue: Codable {
    let booleanValue: Bool?
}

// MARK: - QuestionTypeID
struct IntegerValue: Codable {
    let integerValue: String?
}


typealias QuestionListResponse = [QuestionListResponseElement]
