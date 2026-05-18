// String+Localization.swift
//

import Foundation

extension String {
    var translate: String {
        NetworkingLocalization.translate(self)
    }
}

enum NetworkingLocalization {
    
    static func translate(_ key: String) -> String {
        let bundle = Bundle.main
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
