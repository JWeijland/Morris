//
//  MorrisApp.swift — WisdomMatch
//  "Career wisdom, shared over coffee."
//

import SwiftUI

@main
struct MorrisApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}
