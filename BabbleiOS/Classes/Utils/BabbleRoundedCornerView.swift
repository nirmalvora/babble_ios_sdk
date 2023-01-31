//
//  BabbleRoundedCornerView.swift
//  babbleios
//
//  Created by iMac on 28/01/23.
//

import UIKit

@objc(OBJCBabbleRoundedConrnerView)
class BabbleRoundedConrnerView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = 5.0
        roundCorners(corners: [.topLeft, .topRight], radius: radius)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
