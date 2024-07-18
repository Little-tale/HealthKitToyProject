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
        let bodyInfo = HKQuantityType(.bodyMass)
        
        let healthTypes: Set = [
            steps,
            bodyInfo
        ]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print(error)
            }
        }
    }
    /// 필요한 모든 정보를 방출
    func getInfo() {
        let stepQuery = requestToSteps()
        let userWeightQuery = reqeustUserWeight()
        healthStore.execute(stepQuery)
        healthStore.execute(userWeightQuery)
    }
    
}

// MARK: 요청 로직
extension HealthManager {
    /// 걸음수 요청
    private func requestToSteps() -> HKStatisticsQuery {
        let stpes = HKQuantityType(.stepCount)
        /// 데이터 샘플을 나타내는 데 사용되는 클래스 의 추상 하위 클래스
        let predicated = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        return HKStatisticsQuery(quantityType: stpes, quantitySamplePredicate: predicated) { _, result, error in
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
                    subTitle: HealthInfoType.steps.sub,
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
    }
    
    private func reqeustUserWeight() -> HKSampleQuery {
        let bodyMass = HKQuantityType(.bodyMass)
        
        let body = HKSampleQuery(sampleType: bodyMass, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            let weight = results?.last as? HKQuantitySample
            
            guard let weight = weight else { return }
            let weightDouble = weight.quantity.doubleValue(for: .gramUnit(with: .kilo))
            let str = (String(format: "%.2f", weightDouble) + " KG")
            
            let model = HealthInfo(
                title: HealthInfoType.userWeight.title,
                subTitle:  HealthInfoType.userWeight.sub,
                amout: str,
                rightImage:  HealthInfoType.userWeight.subImage,
                sort:  HealthInfoType.userWeight.sort
            )
            
            DispatchQueue.main.async { [unowned self] in
                healthInfo[HealthInfoType.userWeight.rawValue] = model
            }
        }
        
        return body
    }
    
}

enum HealthInfoType: String, Hashable {
    case steps
    case userWeight
    
    
    var title: String {
        switch self {
        case .steps:
            return "걸음수"
        case .userWeight:
            return "몸무게"
        }
    }
    
    var sub: String {
        switch self {
        case .steps:
            return "최종 목표: 10000"
        case .userWeight:
            return ""
        }
    }
    
    var subImage: String {
        switch self {
        case .steps:
            return "figure.walk"
        case .userWeight:
            return "figure.stand"
        }
    }
    
    var sort: Int {
        switch self {
        case .steps:
            return 0
        case .userWeight:
            return 1
        }
    }
}
