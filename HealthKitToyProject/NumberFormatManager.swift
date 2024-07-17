//
//  NumberFormatManager.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import Foundation


struct NumberFormatManager {
    static let shared = NumberFormatManager()
    private init() {}
    
    private let numberFormatter = NumberFormatter()
    
    func formattedString(with number: NSNumber) -> String? {
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: number)
    }
}
