//
//  ChannelListView.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//

import SwiftUI

/// sidebar contents
struct ChannelListView: View {
    @State var channelHierarchyData: [ChannelItem] = [
        ChannelItem(name: "test-channel") {
            ChannelItem(name: "test thread", type: "thread")
        },
        ChannelItem(name: "test-channel", type: "voice")
    ]
    @State var selected: ChannelItem? = nil
    var body: some View {
        List(channelHierarchyData, id: \.self, children: \.children, selection: $selected) { channel in
            Label(title: { Text(channel.name) },
                      icon: { Image(systemName: channel.icon ).fontWeight(.bold) })
            .frame(height: 30)
        }
        .onAppear {
            selected = channelHierarchyData.first
        }
    }
}
