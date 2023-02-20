//
//  File.swift
//  
//
//  Created by iMac on 29/01/23.
//

import Foundation
import UIKit
class BabbleSurveyController: NSObject {
    var surveyWindow: UIWindow?
    private var isInitialized: Bool = false
    var apiController : APIProtocol = BabbleAPIController()
    var projectDetailsController: ProjectDetailsManageable = BabbleProjectDetailsController.shared
    func initializeSDK(){
        var initApiFailed: Bool = false
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.apiController.getAllSurveys({ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.surveyResponseList = try JSONDecoder().decode(SurveyResponse.self, from: data)
                }
                catch {
                    initApiFailed=true
                    BabbleLog.writeLog("getAllSurveys   parsing failed- Failed")
                }
            } else {
                initApiFailed=true
                BabbleLog.writeLog("getAllSurveys - Failed")
            }
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        })
        dispatchGroup.enter()
        self.apiController.getAllTriggers({ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.triggerListResponse = try JSONDecoder().decode(TriggerListResponse.self, from: data)
                }
                catch {
                    initApiFailed=true
                    BabbleLog.writeLog("getAllTriggers  parsing failed - Failed")
                }
            } else {
                initApiFailed=true
                BabbleLog.writeLog("getAllTriggers - Failed")
            }
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        })
        dispatchGroup.enter()
        self.apiController.getAllQuestions({ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.questionListResponse = try JSONDecoder().decode(QuestionListResponse.self, from: data)
                }
                catch let error{
                    initApiFailed=true
                    BabbleLog.writeLog("getAllQuestions  parsing failed - Failed \(error)")
                }
            } else {
                initApiFailed=true
                BabbleLog.writeLog("getAllQuestions - Failed")
            }
            DispatchQueue.main.async {
                dispatchGroup.leave()   // <<----
            }
        })
        dispatchGroup.enter()
        self.apiController.getStyle({ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.styleListResponse = try JSONDecoder().decode(StyleListResponse.self, from: data)
                    
                    if((self.projectDetailsController.styleListResponse ?? []).count != 0)
                    {
                        if let colorHex = self.projectDetailsController.styleListResponse?[0].document?.fields?.mainColor?.stringValue {
                            let themeColor = UIColor.colorFromHex(colorHex)
                            kBrandColor = themeColor
                        }
                    }
                }
                catch {
                    initApiFailed=true
                    BabbleLog.writeLog("getStyle parsing failed - Failed")
                }
            } else {
                initApiFailed=true
                BabbleLog.writeLog("getStyle - Failed")
            }
            DispatchQueue.main.async {
                dispatchGroup.leave()   // <<----
            }
        })
        dispatchGroup.notify(queue: .main) {
            if(!initApiFailed)
            {
                self.isInitialized = true
            }
        }
    }
    
    
    
    func getCustomerData(userDetails: [String: Any]? = nil){
        apiController.getCohorts({ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.cohortResonse = try JSONDecoder().decode(CohortResonse.self, from: data)
                }
                catch {
                    print("getCohorts json parsing fail")
                    
                }
            } else {
                print("getCohorts Failed")
            }
        })
        
        apiController.getBackendEvents({ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.backendEventResoinse = try JSONDecoder().decode(BackendEventResponse.self, from: data)
                }
                catch {
                    print("getBackendEvents json parsing fail")
                }
            } else {
                print("getBackendEvents Failed")
            }
        })
        
        let eligibleSurveyRequest = EligibleSurveyRequest(babbleUserId: self.projectDetailsController.apiKey!, customerId: self.projectDetailsController.customerId ?? "")
        apiController.getEligibleSurveyIds(eligibleSurveyRequest,{ isSuccess, error, data in
            if isSuccess == true, let data = data {
                do {
                    self.projectDetailsController.eligibleSurveyResponse = try JSONDecoder().decode(EligibleSurveyResponse.self, from: data)
                }
                catch {
                    print("getEligibleSurveyIds json parsing fail")
                }
            } else {
                print("getEligibleSurveyIds Failed")
            }
        })
        
        if(!((userDetails ?? [:]).isEmpty))
        {
            var customerPropertiesRequest = [String: Any]()
            customerPropertiesRequest["properties"] = userDetails
            customerPropertiesRequest["user_id"] = self.projectDetailsController.apiKey!
            customerPropertiesRequest["customer_id"] = self.projectDetailsController.customerId ?? ""
            apiController.setCustomerProperties(customerPropertiesRequest, { isSuccess, error, data in
                if isSuccess == true, let data = data {
                    if let string = String(data: data, encoding: .utf8) {
                        print(string)
                    }
                } else {
                    print("setCustomerProperties failed")
                }
            })
        }
    }
    
    
    func triggerSurvey(triggerName: String,properties: [String: Any]? = nil){
        if(isInitialized){
            if let trigger = self.projectDetailsController.triggerListResponse?.first(where: {($0.document?.fields?.name?.stringValue ?? "") == triggerName})
            {
                let triggerId = ((trigger.document?.name ?? "") as NSString).lastPathComponent
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
                let sortedSurvey = self.projectDetailsController.surveyResponseList?.sorted(by: { dateFormatter.date(from:($0.document?.fields?.createdAt?.stringValue ?? ""))!.compare(dateFormatter.date(from:($1.document?.fields?.createdAt?.stringValue ?? ""))!) == .orderedDescending })
                if let survey = sortedSurvey?.first(where: {($0.document?.fields?.triggerID?.stringValue ?? "") == triggerId})
                {
                    let surveyId = ((survey.document?.name ?? "") as NSString).lastPathComponent
                    
                    
                    let isEligibleSurvey = (self.projectDetailsController.eligibleSurveyResponse?.eligibleSurveyIDS ?? []).contains(surveyId)
                    if(isEligibleSurvey){
                        let questionList = self.projectDetailsController.questionListResponse?.filter({($0.document?.fields?.surveyID?.stringValue ?? "") == surveyId} )
                        let cohortId: String? = survey.document?.fields?.cohortId?.stringValue
                        let eventName: String? = survey.document?.fields?.eventName?.stringValue
                        
                        
                        let eventList =  self.projectDetailsController.backendEventResoinse?.filter({
                            var dateCheck = false
                            let date: Date? = $0.document?.fields?.createdAt?.stringValue ?? "" != "" ? dateFormatter.date(from:($0.document?.fields?.createdAt?.stringValue ?? "")) : nil
                            let currentDate = Date()
                            
                            if(date != nil && survey.document?.fields?.relevancePeriod?.stringValue != nil && !(survey.document?.fields?.relevancePeriod?.stringValue ?? "").isEmpty )
                            {
                                
                                let modifiedDate = Calendar.current.date(byAdding: .hour, value: Int(survey.document?.fields?.relevancePeriod?.stringValue ?? "0")!, to: date!)!
                                
                                dateCheck = modifiedDate > currentDate
                            }
                            if (survey.document?.fields?.relevancePeriod?.stringValue == nil || (survey.document?.fields?.relevancePeriod?.stringValue ?? "").isEmpty) {
                                dateCheck = true
                            }
                            return ($0.document?.fields?.eventName?.stringValue ?? "") == eventName && dateCheck
                        })
                        
                        let cohortIds = self.projectDetailsController.cohortResonse?.map({(($0.document?.name ?? "") as NSString).lastPathComponent}) ?? []
                        let cohortCheck = (cohortId == nil || cohortId!.isEmpty || cohortIds.contains(
                            cohortId!
                        ) == true)
                        
                        let eventCheck = eventName == nil || eventName!.isEmpty || !(eventList ?? []).isEmpty
                        
                        let showSurvey =
                        questionList != nil && !questionList!.isEmpty && cohortCheck && eventCheck
                        
                        if(showSurvey){
                            let sortedQuestionList = questionList?.sorted(by: {
                                let value1 = Int($0.document?.fields?.sequenceNo?.integerValue ?? "0")!
                                let value2 = Int($1.document?.fields?.sequenceNo?.integerValue ?? "0")!
                                return value1 < value2
                                
                            })
                            let surveyInstanceId = self.randomString(length: 10)
                            self.createSurveyInstance(surveyId: surveyId, eventIds: eventList, surveyInstanceId: surveyInstanceId,properties: properties)
                            self.openSurvey(sortedQuestionList!, surveyInstanceId)
                        }else{
                            if(!cohortCheck){
                                BabbleLog.writeLog("Cohort not found for survey id")
                            }
                            if(questionList == nil || (questionList ?? []).isEmpty){
                                BabbleLog.writeLog("Question not found for survey")
                            }
                            if(!eventCheck){
                                BabbleLog.writeLog("Matching event not found for survey")
                            }
                        }
                    }else{
                        BabbleLog.writeLog("Survey id not eligible for customer")
                    }
                }
            }
        }else{
            print("Babble SDK not initialize")
        }
    }
    
    func createSurveyInstance(surveyId: String, eventIds: [BackendEventResponseElement]?, surveyInstanceId: String,properties: [String: Any]? = nil){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        var surveyInstanceRequest = [String: Any]()
        surveyInstanceRequest["properties"] = properties
        surveyInstanceRequest["survey_id"] = surveyId
        surveyInstanceRequest["user_id"] = self.projectDetailsController.apiKey!
        surveyInstanceRequest["time_val"] = dateFormatter.string(from: Date())
        surveyInstanceRequest["customer_id"] = self.projectDetailsController.customerId ?? ""
        surveyInstanceRequest["survey_instance_id"] = surveyInstanceId
        surveyInstanceRequest["device_platform"] = "iOS"
        surveyInstanceRequest["backend_event_ids"] = eventIds?.map({(($0.document?.name ?? "") as NSString).lastPathComponent}) ?? []
        apiController.createSurveyInstance(surveyInstanceRequest, { isSuccess, error, data in
            if isSuccess == true, let data = data {
                if let string = String(data: data, encoding: .utf8) {
                    print(string)
                }
            } else {
                print("createSurveyInstance failed")
            }
        })
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    func openSurvey(_ questionListResponse: [QuestionListResponseElement],_ surveyInstanceId: String){
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                self.surveyWindow = UIWindow(windowScene: currentWindowScene)
            }
            if self.surveyWindow == nil {
                if let currentWindowScene = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first {
                    self.surveyWindow = UIWindow(windowScene: currentWindowScene)
                }
            }
        } else {
            // Fallback on earlier versions
            self.surveyWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        
        if self.surveyWindow == nil {
            return
        }
        self.surveyWindow?.isHidden = false
        self.surveyWindow?.windowLevel = UIWindow.Level.alert
        let controller = BabbleViewController(nibName: "BabbleViewController", bundle: BabbleBundle.bundleForObject(self))
        
        controller.modalPresentationStyle = .overFullScreen
        controller.view.backgroundColor = UIColor.clear
        controller.questionListResponse = questionListResponse
        controller.surveyInstanceId = surveyInstanceId
        self.surveyWindow?.makeKeyAndVisible()
        self.surveyWindow?.rootViewController = controller
        controller.completionBlock = {
            DispatchQueue.main.async {
                self.surveyWindow?.isHidden = true
                self.surveyWindow = nil
            }
        }
    }
}
