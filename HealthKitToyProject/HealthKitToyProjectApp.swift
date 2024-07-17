//
//  HealthKitToyProjectApp.swift
//  HealthKitToyProject
//
//  Created by Jae hyung Kim on 7/17/24.
//

import SwiftUI

@main
struct HealthKitToyProjectApp: App {
    
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
