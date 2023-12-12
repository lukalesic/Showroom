//
//  ShowroomApp.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ShowroomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var manager = ImmersiveViewManager()
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environment(manager)
//                ObjectsView()
//                .environment(manager)
        }

        WindowGroup(id: "object") {
            ObjectView()
                .environment(manager)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
    }
}
