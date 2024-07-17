//
//  CardView.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import SwiftUI

struct CardView: View {
    
    @State var info: HealthInfo
    
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack {
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 5) {
                        Text(info.title)
                            .font(.system(size: 14))
                        Text(info.subTitle)
                            .font(.system(size: 11))
                    }
                    
                    Spacer()
                    
                    Image(systemName: info.rightImage)
                        .foregroundStyle(.green)
                }
                .padding(.horizontal, 15)
                
                Text(info.amout)
                    .font(.system(size: 24, weight: .bold))
            }
        }

    }
}


