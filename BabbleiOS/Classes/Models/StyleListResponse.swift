//
//  File.swift
//  
//
//  Created by iMac on 29/01/23.
//

import Foundation

// MARK: - SurveyResponseElement
struct StyleListResponseElement: Codable {
    let document: StyleDocument?
    let readTime: String?
}

// MARK: - Document
struct StyleDocument: Codable {
    let name: String?
    let fields: StyleFields?
    let createTime, updateTime: String?
}

// MARK: - Fields
struct StyleFields: Codable {
    let userID, mainColor: StringValue?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case mainColor = "main_color"
    }
}


typealias StyleListResponse = [StyleListResponseElement]
