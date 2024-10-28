//
//  Nin0chatApp.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

import SwiftUI

@main
struct Nin0chatApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowToolbarStyle(.unified)
#if os(macOS)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutPanel()
                }) {
                    Text("About Nin0chat")
                }
            }
        }
#endif

#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}
