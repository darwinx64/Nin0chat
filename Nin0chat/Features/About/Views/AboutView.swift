//
//  AboutView.swift
//  Wcode
//
//  Created by samara on 1/25/24.
//

/// src: https://github.com/CodeEditApp/CodeEdit/blob/main/CodeEdit/Features/About/Views/AboutView.swift

import SwiftUI

enum AboutMode: String, CaseIterable {
    case about
    case contributors
}

public struct AboutView: View {
    @Environment(\.openURL)
    private var openURL
    @Environment(\.colorScheme)
    private var colorScheme
    @Environment(\.dismiss)
    private var dismiss

    @State var aboutMode: AboutMode = .about

    @Namespace var animator

    public var body: some View {
        ZStack(alignment: .top) {
            switch aboutMode {
            case .about:
                AboutDefaultView(aboutMode: $aboutMode, namespace: animator)
            case .contributors:
                ContributorsView(aboutMode: $aboutMode, namespace: animator)
            }
        }
        .animation(.spring(), value: aboutMode)
        .ignoresSafeArea()
        .frame(width: 280, height: 300)
        .fixedSize()
        .background(.regularMaterial.opacity(0))
        .background(EffectView(.popover, blendingMode: .behindWindow).ignoresSafeArea())
        .background {
            Button("") {
                dismiss()
            }
            .keyboardShortcut(.escape, modifiers: [])
            .hidden()
        }
    }
}
