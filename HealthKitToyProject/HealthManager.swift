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
    
    @Published
    var healthInfo: [String: HealthInfo] = [:]
    
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
       
    func getInfo() {
        let stpes = HKQuantityType(.stepCount)
        /// 데이터 샘플을 나타내는 데 사용되는 클래스 의 추상 하위 클래스
        let predicated = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stpes, quantitySamplePredicate: predicated) { _, result, error in
            guard let result = result, error == nil else {
                print("문제발생")
                return
            }
            guard let quantity = result.sumQuantity() else {
                print("HKQuery Error")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            if let stepString = stepCount.formatToString() {
                let model = HealthInfo(
                    title: HealthInfoType.steps.title,
                    subTitle: HealthInfoType.steps.subImage,
                    amout: stepString,
                    rightImage: HealthInfoType.steps.subImage,
                    sort: HealthInfoType.steps.sort
                )
                
                DispatchQueue.main.async { [unowned self] in
                    healthInfo[HealthInfoType.steps.rawValue] = model
                }
                
            } else {
                return
            }
        }
        
        
        healthStore.execute(query)
    }
    
}

enum HealthInfoType: String, Hashable {
    case steps
    
    var title: String {
        switch self {
        case .steps:
            return "걸음수"
        }
    }
    
    var sub: String {
        switch self {
        case .steps:
            return "최종 목표: 10000"
        }
    }
    
    var subImage: String {
        switch self {
        case .steps:
            return "figure.walk"
        }
    }
    
    var sort: Int {
        switch self {
        case .steps:
            return 0
        }
    }
}
