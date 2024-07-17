//
//  ExDate.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import Foundation

extension Date {
    static var startOfDay: Date {
        return Calendar.current.startOfDay(for: Date())
    }
}
