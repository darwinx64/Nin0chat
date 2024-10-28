//
//  SettingsView.swift
//  Nin0chat
//
//  Created by tiramisu on 10/24/24.
//

import Setting
import SwiftUI

struct SettingsView: View {
    @AppStorage("customWsHost") var customWsHost = SettingsDefaults.customWsHost
    @AppStorage("loggingPolicy") var loggingPolicy = SettingsDefaults.loggingPolicy
    var body: some View {
        SettingStack {
            SettingPage(title: "nin0chat Settings") {
                SettingGroup(header: "General", dividerColor: .clear) {
                    SettingCustomView {
                        Text("")
                            .padding(.bottom, 5)
                    }
                    SettingGroup(header: "Websocket URL") {
                        SettingTextField(placeholder: "wss://chatws.nin0.dev", text: $customWsHost)
                    }
                    SettingPage(title: "Advanced Settings") {
                        SettingToggle(title: "Log errors to file", isOn: $loggingPolicy)
                    }
                }
            }
        }
#if os(macOS)
        .textFieldStyle(.roundedBorder)
#endif
    }
}

#Preview {
    SettingsView()
}
