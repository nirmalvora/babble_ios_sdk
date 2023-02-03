//
//  File.swift
//  
//
//  Created by iMac on 30/01/23.
//

import Foundation
import Foundation

protocol BabbleSurveyResponseProtocol: AnyObject {
    func onWelcomeNextTapped()
    func textSurveySubmit(_ text:String?)
    func numericRatingSubmit(_ text: Int?)
    func singleAndMultiSelectionSubmit(_ selectedOptions:[String])
}
