//
//  ContentView.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import SwiftUI
/*
 헬스 킷 (p: Phone, W: 웨어러블 기기)
    기본 앱 가져오는 데이터
        -w 심박수 heartRate
        -w 휴식기 심박수 restingHeartRate
        -w 심박 변이 walkingHeartRateAcerage
        -w 걷기 심박수 평균 heartRateVariabilitySDNN
        ... 생략 
        워치가 없는관계로 폰으로 가능한것만 정리
        -p 수면
        
        -p 보행 속도 walkingSpeed
        -p 보행 비대칭성 walkingAsymmetryPercentage
        -p 이중 지지 시간 walkingDoubleSupportPercentage
        -p 보행 보폭 walkingStepLength
        -p 보행 안정성 appleWalkingSteadiness
        ...
        -p 걷기 + 달리기 거리 distanceWalkingRunning
        -p 활동 에너지 activeEnergyBurned
        -p 오른 층계 flightsClimbed
        -p 걸음 stepCount
        -p 휴식 에너지 basalEnergyBurned
 */
struct ContentView: View {
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
