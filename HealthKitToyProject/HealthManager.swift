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
//        let sleepType = HKQuantityType(.appleSleepingWristTemperature) // 손목온도....
        let sleepType = HKCategoryType(.sleepAnalysis)
        
        let healthTypes: Set = [
            steps,
            bodyInfo,
            sleepType
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
        let sleepQuery = reqeustUserSleepData()
        
        healthStore.execute(stepQuery)
        healthStore.execute(userWeightQuery)
        healthStore.execute(sleepQuery)
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
    
    
    func reqeustUserSleepData() ->  HKSampleQuery {
        let sleepType = HKCategoryType(.sleepAnalysis)
        /// HKCategoryValueSleepAnalysis  @available(iOS 16.0, *)
        let sleepData = HKCategoryValueSleepAnalysis.asleepDeep.rawValue
        /// HKCategoryType 예전엔 직접 샘플 필터를 통해 각 수면 데이터를 가져와야함.
//        let beforeDataType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        // 날짜 범위 세팅
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
//        //  NSPredicate
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let body = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            
            guard let results = results as? [HKCategorySample] else {
                print("수면 데이터 에러가 발생했습니다: \(String(describing: error))")
                return
            }
            
            let totalSleepTime = results
                .filter { sample in
                    return sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue
                }
                .reduce(0){ total, sample in // O(*n*)
                    return total + sample.endDate.timeIntervalSince(sample.startDate)
                }
            // 총 수면 시간 계산 및 출력
            let hours = totalSleepTime / 3600
            let minutes = (totalSleepTime.truncatingRemainder(dividingBy: 3600)) / 60
            let sleepTimeString = String(format: "%.0f시간 %.0f분", hours, minutes)
            
            let model = HealthInfo(
                title: HealthInfoType.sleep.title,
                subTitle:  HealthInfoType.sleep.sub,
                amout: sleepTimeString,
                rightImage:  HealthInfoType.sleep.subImage,
                sort:  HealthInfoType.sleep.sort
            )
            
            DispatchQueue.main.async { [unowned self] in
                healthInfo[HealthInfoType.sleep.rawValue] = model
            }
        }
    
        return body
    }
    
}

/*
 let sampleData = HKCategorySample(
     type: sleepType,
     value: sleepData,
     start: startDate,
     end: endDate
 )
 */

enum HealthInfoType: String, Hashable {
    case steps
    case userWeight
    case sleep
    
    var title: String {
        switch self {
        case .steps:
            return "걸음수"
        case .userWeight:
            return "몸무게"
        case .sleep:
            return "수면 시간"
        }
    }
    
    var sub: String {
        switch self {
        case .steps:
            return "최종 목표: 10000"
        case .userWeight:
            return ""
        case .sleep:
            return "권장 수면: 8시간"
        }
    }
    
    var subImage: String {
        switch self {
        case .steps:
            return "figure.walk"
        case .userWeight:
            return "figure.stand"
        case .sleep:
            return "bed.double.fill"
        }
    }
    
    var sort: Int {
        switch self {
        case .steps:
            return 0
        case .userWeight:
            return 1
        case .sleep:
            return 2
        }
    }
}
