//
//  HealthManager.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import Foundation
import HealthKit

final class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    init() {
        //  숫자 값 데이터 유형
        let steps = HKQuantityType(.stepCount)
        
        let healthTypes: Set = [steps]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print(error)
            }
        }
    }
}

