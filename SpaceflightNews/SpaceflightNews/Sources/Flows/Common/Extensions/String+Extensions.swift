//
//  String+Extensions.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import Foundation

extension String {
    var translate: String {
        SpaceFlightNewsLocalization.translate(self)
    }
}

enum SpaceFlightNewsLocalization {
    
    static func translate(_ key: String) -> String {
        let bundle = Bundle.main
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
