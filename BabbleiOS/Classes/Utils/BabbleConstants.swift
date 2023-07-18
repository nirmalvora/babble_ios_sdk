//
//  BabbleConstants.swift
//  babbleios
//
//  Created by iMac on 28/01/23.
//

import Foundation
import UIKit

var kBrandColor = UIColor(red: 0.36, green: 0.37, blue: 0.93, alpha: 1.0)
var greenColor = UIColor.colorFromHex("3eaa1c")
var redColor = UIColor.colorFromHex("FF0000")
var kBrandHightlightColor = kBrandColor.withAlphaComponent(0.21)
var kPrimaryTitleColor = UIColor.black
var kSecondaryTitleColor = kPrimaryTitleColor.withAlphaComponent(0.8)
var kFooterColor = UIColor.colorFromHex("787878")
var kOptionBackgroundColor = UIColor.colorFromHex("F3F3F3")
var kOptionBackgroundColorHightlighted = UIColor.white
var kWatermarkColor = kPrimaryTitleColor.withAlphaComponent(0.6)
var kWatermarkColorHightlighted = kPrimaryTitleColor.withAlphaComponent(0.05)
var kCloseButtonColor = kPrimaryTitleColor.withAlphaComponent(0.6)
var kBackgroundColor = UIColor.white
var kSubmitButtonColorDisable = kBrandColor.withAlphaComponent(0.5)
var kPlaceholderColor = kPrimaryTitleColor.withAlphaComponent(0.3)

let kBorderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.0)
let kAppGreyBGColor = UIColor.colorFromHex("F3F3F3")
let baseURL = "https://babble-app-api-e56ea46dbbcb.herokuapp.com/"

extension UIColor {
    
    class func colorFromHex(_ hex: String) -> UIColor {
        if hex.count == 8 {
            let color = UIColor(hexaRGBA: hex)
            return color ?? kBrandColor
        } else {
            let color = UIColor(hexaRGB: hex)
            return color ?? kBrandColor
        }
    }
    
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }

    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }

    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}
