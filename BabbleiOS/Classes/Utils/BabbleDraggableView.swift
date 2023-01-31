//
//  BabbleDraggableView.swift
//  babbleios
//
//  Created by iMac on 28/01/23.
//

import UIKit
class BabbleDraggableView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}

