//
//  File.swift
//  
//
//  Created by iMac on 30/01/23.
//


import Foundation
import UIKit

protocol BabbleViewLoading {}
extension UIView : BabbleViewLoading {}

extension BabbleViewLoading where Self : UIView {

  static func loadFromNib() -> Self {
    let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
    let nib = UINib(nibName: nibName, bundle: BabbleBundle.bundleForObject(self))
    return nib.instantiate(withOwner: self, options: nil).first as! Self
  }
}
