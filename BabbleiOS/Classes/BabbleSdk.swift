//
//  BabbleSdk.swift
//  babbleios
//
//  Created by iMac on 27/01/23.
//

import Foundation
public final class BabbleSdk: NSObject {
    static let shared = BabbleSdk()
    var babbleSurveyController = BabbleSurveyController()
    var projectDetailsController: ProjectDetailsManageable = BabbleProjectDetailsController.shared

    private override init() {
    }
    
    @objc public class func configure(_ apiKey: String) {
        if(apiKey.isEmpty){
            BabbleLog.writeLog("Provide api key")
        }else{
            shared.projectDetailsController.apiKey = apiKey
            shared.babbleSurveyController.initializeSDK()
        }
    }
    

    @objc public class func generateCustomerId() -> String {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = String((0..<10).map { _ in chars.randomElement()! })
        return "Anon" + randomString
    }
    
    @objc public class func setCustomerId(_ customerId: String?,userDetails: [String: Any]? = nil) {
        shared.projectDetailsController.customerId = customerId != nil && customerId != "" ? customerId : generateCustomerId()
        shared.babbleSurveyController.getCustomerData(userDetails: userDetails)
        
    }
    
    @objc public class func trigger(_ trigger: String,properties: [String: Any]? = nil) {
        if(trigger.isEmpty){
            BabbleLog.writeLog("Provide trigger")
        }else{
            shared.babbleSurveyController.triggerSurvey(triggerName:trigger, properties: properties)
        }
    }
    
    @objc public class func cancelSurvey() {
        shared.babbleSurveyController.cancelSurvey()
    }
}
