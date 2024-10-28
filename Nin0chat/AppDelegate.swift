//
//  AppDelegate.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//

#if os(macOS)
import Foundation
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var aboutBoxWindowController: NSWindowController?
    func showAboutPanel() {
        if aboutBoxWindowController == nil {
            let hostingController = NSHostingController(rootView: AboutView())

            let window = NSWindow(contentViewController: hostingController)
            window.title = ""

            window.styleMask = [.closable, .fullSizeContentView, .titled, .nonactivatingPanel]
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.backgroundColor = .gray.withAlphaComponent(0.15)
            window.isMovableByWindowBackground = true
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden

            window.center()

            window.makeKeyAndOrderFront(nil)
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
    func applicationDidBecomeActive(_ notification: Notification) {}
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
#endif
