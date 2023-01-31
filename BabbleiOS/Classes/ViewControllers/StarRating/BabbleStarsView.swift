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

@objc(OBJCBabbleStarsView)
class BabbleStarsView: UIView {
    @IBOutlet weak var lblMinValue: UILabel!
    @IBOutlet weak var lblMaxValue: UILabel!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var btnFinish: UIButton!
    weak var delegate: BabbleSurveyResponseProtocol?
    
    var selectedButton: UIButton? {
        didSet {
        }
    }
    var submitButtonTitle : String = "Submit" {
        didSet {
            btnFinish.setTitle(self.submitButtonTitle, for: .normal)
        }
    }
    
    var ratingMaxText: String? {
        didSet {
            if ratingMaxText != nil {
                self.lblMaxValue.text = ratingMaxText
            }
        }
    }
    
    var ratingMinText: String? {
        didSet {
            if ratingMinText != nil {
                self.lblMinValue.text = ratingMinText
            }
        }
    }
    
    @IBAction func onContinueTapped(_ sender: Any) {
        self.delegate?.numericRatingSubmit(selectedButton?.tag ?? 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(checkGestureAction(_:)))
        self.stackView1.addGestureRecognizer(gesture)
        self.setupImages()
        btnFinish.layer.cornerRadius = 5.0
        btnFinish.isHidden = false
        self.lblMaxValue.textColor = kFooterColor
        self.lblMinValue.textColor = kFooterColor
        btnFinish.backgroundColor = kSubmitButtonColorDisable
        btnFinish.isUserInteractionEnabled = false
    }
    
    func setupImages() {
        let starImage = UIImage.init(named: "unSelectedStar", in: BabbleBundle.bundleForObject(self), compatibleWith: nil)
        let filledStarImage = UIImage.init(named: "selectedStar", in: BabbleBundle.bundleForObject(self), compatibleWith: nil)
        for view in self.stackView1.arrangedSubviews {
            if let btn = view as? UIButton {
                btn.setImage(starImage, for: .normal)
                btn.setImage(filledStarImage, for: .selected)
            }
        }
    }
    
    @IBAction func onSelectButton(_ sender: UIButton) {
        let index = sender.tag
        _ = self.stackView1.arrangedSubviews.map { view in
            if let btn = view as? UIButton {
                if btn.tag <= index {
                    btn.isSelected = true
                } else {
                    btn.isSelected = false
                }
            }
        }
        btnFinish.backgroundColor = kBrandColor
        btnFinish.isUserInteractionEnabled = true
        self.selectedButton = sender
    }
    
    @objc func checkGestureAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let location = sender.location(in: self.stackView1)
            let filteredSubviews = self.stackView1.subviews.filter { subView -> Bool in
                return subView.frame.contains(location)
            }
            guard let subviewTapped = filteredSubviews.first else {
                return
            }
            let index = subviewTapped.tag
            _ = self.stackView1.arrangedSubviews.map { view in
                if let btn = view as? UIButton {
                    if btn.tag <= index {
                        btn.isSelected = true
                    } else {
                        btn.isSelected = false
                    }
                }
            }
        } else if sender.state == .ended {
            if let temp = self.stackView1.arrangedSubviews.last(where: { view in
                if let btn = view as? UIButton {
                    return btn.isSelected == true
                } else {
                    return false
                }
            }) {
                self.onSelectButton(temp as! UIButton)
            }
            
        }
    }
}
