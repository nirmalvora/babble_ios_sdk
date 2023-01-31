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

import Foundation

typealias APICompletionBlock = ((Bool, Error?, Data?) -> Void)

protocol APIProtocol {
    func getAllSurveys(_ completion: @escaping APICompletionBlock)
    func getAllTriggers(_ completion: @escaping APICompletionBlock)
    func getAllQuestions(_ completion: @escaping APICompletionBlock)
    func getStyle(_ completion: @escaping APICompletionBlock)
    func getCohorts(_ completion: @escaping APICompletionBlock)
    func getBackendEvents(_ completion: @escaping APICompletionBlock)
    func createSurveyInstance(_ request:  SurveyInstanceRequest,_ completion: @escaping APICompletionBlock)
    func addResponse(_ request:  AddResponseRequest,_ completion: @escaping APICompletionBlock)
    func getEligibleSurveyIds(_ request:  EligibleSurveyRequest,_ completion: @escaping APICompletionBlock)
}

final class BabbleAPIController: NSObject, APIProtocol {
    var urlRequestManager: URLRequestManagerProtocol = URLRequestManager()

    func getAllSurveys(_ completion: @escaping APICompletionBlock) {
        urlRequestManager.getAPIWith("get_surveys_for_user_id",header: ["user_id":BabbleProjectDetailsController.shared.apiKey ], completion: completion)
    }
    
    func getAllTriggers(_ completion: @escaping APICompletionBlock) {
        urlRequestManager.getAPIWith("get_triggers_for_user_id",header: ["user_id":BabbleProjectDetailsController.shared.apiKey ], completion: completion)
    }
    
    func getAllQuestions(_ completion: @escaping APICompletionBlock) {
        urlRequestManager.getAPIWith("get_questions_for_user_id",header: ["user_id":BabbleProjectDetailsController.shared.apiKey ], completion: completion)
    }

    func getStyle(_ completion: @escaping APICompletionBlock) {
        urlRequestManager.getAPIWith("get_styles_for_user_id",header: ["user_id":BabbleProjectDetailsController.shared.apiKey ], completion: completion)
    }
    
    func getCohorts(_ completion: @escaping APICompletionBlock) {
        urlRequestManager.getAPIWith("get_cohorts",header: ["babble_user_id":BabbleProjectDetailsController.shared.apiKey ,"customer_id":BabbleProjectDetailsController.shared.customerId ], completion: completion)
    }
    
    func getBackendEvents(_ completion: @escaping APICompletionBlock) {
        urlRequestManager.getAPIWith("get_backend_events",header: ["user_id":BabbleProjectDetailsController.shared.apiKey ,"customer_id":BabbleProjectDetailsController.shared.customerId ], completion: completion)
    }
    
    func createSurveyInstance(_ request:  SurveyInstanceRequest,_ completion: @escaping APICompletionBlock) {
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequestManager.postAPIWith("create_survey_instance",parameters: jsonData,header: [:], completion: completion)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addResponse(_ request:  AddResponseRequest,_ completion: @escaping APICompletionBlock) {
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequestManager.postAPIWith("write_survery_question_response",parameters: jsonData, header: ["babble_user_id":BabbleProjectDetailsController.shared.apiKey!], completion: completion)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getEligibleSurveyIds(_ request:  EligibleSurveyRequest,_ completion: @escaping APICompletionBlock)
    {
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequestManager.postAPIWith("eligible_survey_ids",parameters: jsonData, header: [:], completion: completion)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
