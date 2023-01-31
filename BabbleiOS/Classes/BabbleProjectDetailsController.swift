// Copyright 2021 1Flow, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import CoreTelephony
import Foundation
import UIKit

protocol ProjectDetailsManageable {
    var apiKey: String! { get set }
    var customerId: String! { get set }
    var surveyResponseList: [SurveyResponseElement]? {get set}
    var triggerListResponse: [TriggerListResponseElement]? {get set}
    var questionListResponse: [QuestionListResponseElement]? {get set}
    var styleListResponse: [StyleListResponseElement]? {get set}
    var backendEventResoinse: [BackendEventResponseElement]? {get set}
    var cohortResonse: [CohortResonseElement]? {get set}
    var eligibleSurveyResponse: EligibleSurveyResponse? {get set}
}

final class BabbleProjectDetailsController: NSObject, ProjectDetailsManageable {

    static let shared = BabbleProjectDetailsController()
    var apiKey: String! {
        get {
            return UserDefaults.standard.value(forKey: "ApiKey") as? String
        }

        set {
            if let value = newValue {
                UserDefaults.standard.setValue(value, forKey: "ApiKey")
            } else {
                UserDefaults.standard.removeObject(forKey: "ApiKey")
            }
        }
    }
    var customerId: String! {
        get {
            return UserDefaults.standard.value(forKey: "customerId") as? String
        }

        set {
            if let value = newValue {
                UserDefaults.standard.setValue(value, forKey: "customerId")
            } else {
                UserDefaults.standard.removeObject(forKey: "customerId")
            }
        }
    }
    
    var surveyResponseList: [SurveyResponseElement]?
    
    var triggerListResponse: [TriggerListResponseElement]?
    
    var questionListResponse: [QuestionListResponseElement]?
    
    var styleListResponse: [StyleListResponseElement]?
    
    var backendEventResoinse: [BackendEventResponseElement]?
    
    var cohortResonse: [CohortResonseElement]?
    
    var eligibleSurveyResponse: EligibleSurveyResponse?
}
