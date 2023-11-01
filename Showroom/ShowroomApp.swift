//
//  ShowroomApp.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI

@main
struct ShowroomApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
