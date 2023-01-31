//
//  BabbleBundle.swift
//  babbleios
//
//  Created by iMac on 27/01/23.
//

import Foundation


class BabbleBundle {
    class func bundleForObject(_ obj: AnyObject) -> Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return BabbleBundle.resourceBundle
        #endif
    }
}

extension BabbleBundle {
    static let resourceBundle: Bundle = {
        let myBundle = Bundle(for: BabbleBundle.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "SurveySDK", withExtension: "bundle")
            else { fatalError("babbleios.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access babbleios.bundle!") }

        return resourceBundle
    }()
}
