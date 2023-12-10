//
//  File.swift
//  
//
//  Created by iMac on 30/01/23.
//

import UIKit
@objc(OBJCBabbleTextView)
class BabbleTextView: UIView {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnFinish: UIButton!

    weak var delegate: BabbleSurveyResponseProtocol?
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    var minCharsAllowed = 5 {
        didSet {
//            if minCharsAllowed == 0 {
//                self.btnFinish.alpha = 1.0
//                self.btnFinish.isHidden = false
//                btnFinish.backgroundColor = kBrandColor
//                btnFinish.isUserInteractionEnabled = true
//            }
        }
    }
    var placeHolderText = "Write here..." {
        didSet {
            self.placeholderLabel.text = placeHolderText
            self.placeholderLabel.sizeToFit()
        }
    }
    var placeholderLabel : UILabel!
    var enteredText: String? {
        didSet {
//            if enteredText?.count ?? 0 >= minCharsAllowed {
//                btnFinish.backgroundColor = kBrandColor
//                btnFinish.isUserInteractionEnabled = true
//
//            } else {
//                btnFinish.backgroundColor = kSubmitButtonColorDisable
//                btnFinish.isUserInteractionEnabled = false
//
//            }
        }
    }
    var submitButtonTitle : String = "Submit Feedback" {
        didSet {
            btnFinish.setTitle(self.submitButtonTitle, for: .normal)
        }
    }
    var keyboardHeight: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.layer.borderColor = kBorderColor.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 2.0
        textView.backgroundColor = UIColor.clear
        textView.textColor = textColor
        placeholderLabel = UILabel()
        placeholderLabel.text = placeHolderText
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize ?? 16) / 2)
        placeholderLabel.textColor = textColor.withAlphaComponent(0.5)
        placeholderLabel.isHidden = !textView.text.isEmpty
        btnFinish.layer.cornerRadius = 5.0
        textView.tintColor = textColor
        btnFinish.isHidden = false
        btnFinish.backgroundColor = kBrandColor
        btnFinish.isUserInteractionEnabled = true
//        btnFinish.backgroundColor = kSubmitButtonColorDisable
//        btnFinish.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func onFinished(_ sender: UIButton) {
        if let text = textView.text{
            self.isUserInteractionEnabled = false
            self.delegate?.textSurveySubmit(text)
        }
//        if let text = textView.text, text.count >= minCharsAllowed {
//            self.isUserInteractionEnabled = false
//            self.delegate?.textSurveySubmit(text)
//        }
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyboardHeight = keyboardFrame.size.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboardHeight = 0
    }
    
}

extension BabbleTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
        self.enteredText = textView.text
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = newSize.height > 109 ? newSize.height : 109
        //App calculates height which total screen hight - open keyboard size - safe area instest - 20 (this is to give some gap)
        let availableHeight: CGFloat
        if #available(iOS 11.0, *) {
            availableHeight = CGFloat(UIScreen.main.bounds.size.height - window.safeAreaInsets.top -  keyboardHeight - 30 )
        } else {
            availableHeight = CGFloat(UIScreen.main.bounds.size.height -  keyboardHeight - 30 )
        }
    
        if let frame = textView.superview?.superview?.superview?.superview?.superview?.frame {
            if (frame.size.height < availableHeight) || (newHeight < textView.bounds.height) {
                self.textViewHeightConstraint.constant = newHeight
            }
        }       
    }
}
