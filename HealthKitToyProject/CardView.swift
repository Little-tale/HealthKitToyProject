//
//  CardView.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import SwiftUI

struct CardView: View {
    
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack {
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 5) {
                        Text("걸음수")
                            .font(.system(size: 14))
                        Text("오늘의 목표 : ")
                            .font(.system(size: 11))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "figure.walk")
                        .foregroundStyle(.green)
                }
                .padding(.horizontal, 15)
                
                Text("1,000")
                    .font(.system(size: 24, weight: .bold))
            }
        }

    }
}


#Preview {
    CardView()
}

