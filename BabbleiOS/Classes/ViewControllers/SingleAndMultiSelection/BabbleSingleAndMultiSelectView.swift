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

import UIKit

@objc(OBJCBabbleSingleAndMultiSelectView)
class BabbleSingleAndMultiSelectView: UIView {

    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    weak var delegate: BabbleSurveyResponseProtocol?
    @IBOutlet weak var btnFinish: UIButton!
    var currentType:  BabbleRadioButton.BabbleRadioButtonType = BabbleRadioButton.BabbleRadioButtonType.radioButton
    var allOptions: [Codable]?

    let textFieldViewTag = 1001
    let enterButtonTag = 1002

    var otherOptionTF: UITextField!
    var otherOptionAnswer = ""
    var parentWidth: CGFloat = 0.0

    var selectedButton: UIButton? {
        didSet {
        }
    }

    var submitButtonTitle : String = "Submit" {
        didSet {
            btnFinish.setTitle(self.submitButtonTitle, for: .normal)
        }
    }
   
    func setupViewWithOptions(_ options: [StringValue], type: BabbleRadioButton.BabbleRadioButtonType, parentViewWidth: CGFloat) {
        self.currentType = type
        self.allOptions = options
        parentWidth = parentViewWidth
        btnFinish.layer.cornerRadius = 5.0
        btnFinish.isHidden = false
        btnFinish.backgroundColor = kSubmitButtonColorDisable
        btnFinish.isUserInteractionEnabled = false
        bottomConstraint.constant = 53.0
        
        while let first = stackView1.arrangedSubviews.first {
            stackView1.removeArrangedSubview(first)
                first.removeFromSuperview()
        }
        
        for i in 0..<options.count {
            let option = options[i]
                let button = BabbleRadioButton(frame: CGRect(x: 0, y: 0, width: parentViewWidth, height: 43), type: type)
                button.titleLabel?.lineBreakMode = .byWordWrapping
                button.setTitle(option.stringValue  ?? "", for: .normal)
                button.tag = i
                button.addTarget(self, action: #selector(onSelectButton(_:)), for: .touchUpInside)
                self.stackView1.addArrangedSubview(button)
                let height = self.labelSize(for: option.stringValue ?? "", maxWidth: (parentViewWidth))
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: height + 24).isActive = true
        }
    }

    func setHeightForButton(_ button : UIButton ) {
        if var buttonTitle = button.title(for: .normal) {
            if buttonTitle.isEmpty {
                buttonTitle = "Dummy Text"
            }
            let newHeight = self.labelSize(for: buttonTitle, maxWidth: (parentWidth - 54))
            button.constraints.forEach { (constraint) in
                 if constraint.firstAttribute == .height
                 {
                     constraint.constant = newHeight + 24
                 }
             }
        }
    }
    
    func labelSize(for text: String, maxWidth: CGFloat) -> CGFloat {
        
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func setupFinishButton() {
        var isAnySelected = false
        for view in self.stackView1.arrangedSubviews {
            if let btn = view as? UIButton {
                if btn.isSelected == true {
                    isAnySelected = true
                    break
                }
            }
        }
        if isAnySelected == true {
            btnFinish.backgroundColor = kBrandColor
            btnFinish.isUserInteractionEnabled = true
        } else {
            btnFinish.backgroundColor = kSubmitButtonColorDisable
            btnFinish.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func onFinishTaped(_ sender: UIButton) {
        var selectedOptionIDs = [String]()
        for view in self.stackView1.arrangedSubviews {
            if let btn = view as? UIButton {
                if btn.isSelected == true {
                    selectedOptionIDs.append(btn.currentTitle!)
                }
            }
        }
        self.delegate?.singleAndMultiSelectionSubmit(selectedOptionIDs)
    }
    

    @IBAction func onSelectButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.currentType == .radioButton {
            self.selectedButton?.isSelected = false
            if sender.isSelected == true {
                self.selectedButton = sender
            } else {
                self.selectedButton = nil
            }
        }
        self.setupFinishButton()
    }
}

