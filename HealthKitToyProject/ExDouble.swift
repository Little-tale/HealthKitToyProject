//
//  ExDouble.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import Foundation

extension Double {
    func formatToString() -> String? {
        let result = NumberFormatManager.shared.formattedString(with: NSNumber(value: self))
        return result
    }
}
