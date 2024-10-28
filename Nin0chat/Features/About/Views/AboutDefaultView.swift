//
//  AboutDefaultView.swift
//  Wcode
//
//  Created by tiramisu on 10/19/24.
//

/// src: https://github.com/CodeEditApp/CodeEdit/blob/main/CodeEdit/Features/About/Views/AboutDetailView.swift

import SwiftUI

public extension Image {
    init(symbol: String) {
        self.init(symbol, bundle: Bundle.main)
    }
    
    static let github: Image = .init(symbol: "github")
}

struct AboutDefaultView: View {
    private var appVersion: String {
        "No Version"
    }

    private var appBuild: String {
        "No Build"
    }

    private var appVersionPostfix: String {
        ""
    }

    @Binding var aboutMode: AboutMode
    var namespace: Namespace.ID

    @Environment(\.colorScheme)
    var colorScheme

    private static var licenseURL = URL(string: "https://github.com/darwinx64/Nin0chat/blob/main/LICENSE")!

    let smallTitlebarHeight: CGFloat = 28
    let mediumTitlebarHeight: CGFloat = 113
    let largeTitlebarHeight: CGFloat = 231
    
    @State private var iconBlurOpacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .matchedGeometryEffect(id: "AppIcon", in: namespace)
                    .frame(width: 128, height: 128)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .matchedGeometryEffect(id: "AppIcon", in: namespace)
                    .frame(width: 128, height: 128)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .blur(radius: 50)
                    .opacity(iconBlurOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 2.0)) {
                            iconBlurOpacity = 0.4
                        }
                    }
            }

            VStack(spacing: 0) {
                Text("Nin0chat")
                    .matchedGeometryEffect(id: "Title", in: namespace, properties: .position, anchor: .center)
                    .foregroundColor(.primary)
                    .font(.system(
                        size: 26,
                        weight: .bold
                    ))
                Text("Version \(appVersion)\(appVersionPostfix) (\(appBuild))")
                    .textSelection(.enabled)
                    .foregroundColor(Color(.tertiaryLabelColor))
                    .font(.body)
                    .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                    .padding(.top, 4)
                    .matchedGeometryEffect(
                        id: "Title",
                        in: namespace,
                        properties: .position,
                        anchor: UnitPoint(x: 0.5, y: -0.75)
                    )
            }
            .padding(.horizontal)
        }
        .padding(24)

        VStack {
            Spacer()
            VStack {
                Button {
                    aboutMode = .contributors
                } label: {
                    Text("Contributors")
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .buttonStyle(.blur)

                VStack(spacing: 2) {
                    Link(destination: Self.licenseURL) {
                        Text("MIT License")
                            .underline()

                    }
                }
                .textSelection(.disabled)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(.tertiaryLabelColor))
                .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .matchedGeometryEffect(id: "Titlebar", in: namespace, properties: .position, anchor: .top)
            .matchedGeometryEffect(id: "ScrollView", in: namespace, properties: .position, anchor: .top)
        }
        .padding(.horizontal)
    }
}
