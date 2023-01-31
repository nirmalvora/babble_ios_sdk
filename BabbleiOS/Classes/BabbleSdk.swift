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
    


    @objc public class func setCustomerId(_ customerId: String) {
        if(customerId.isEmpty){
            BabbleLog.writeLog("Provide customer id")
        }else{
            shared.projectDetailsController.customerId = customerId
            shared.babbleSurveyController.getCustomerData()
        }
        
    }
    
    @objc public class func trigger(_ trigger: String) {
        if(trigger.isEmpty){
            BabbleLog.writeLog("Provide trigger")
        }else{
            shared.babbleSurveyController.triggerSurvey(trigger)
        }
    }
}
