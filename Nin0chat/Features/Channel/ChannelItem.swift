//
//  ChannelItem.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//


/// representation of a channel within the channel list sidebar
struct ChannelItem: Hashable, Identifiable {
    var id: Self { self }
    var name: String
    var type: String = "Text"
    var children: [ChannelItem]? = nil
    var icon: String {
        switch type {
        case "thread":
            return "number.square"
        case "voice":
            return "mic"
        default:
            return "number"
        }
    }
    
    init(name: String, type: String = "Text", @ChannelItemBuilder children: () -> [ChannelItem]? = {nil}) {
        self.name = name
        self.type = type
        self.children = children()
    }
}

@resultBuilder
struct ChannelItemBuilder {
    static func buildBlock(_ components: ChannelItem...) -> [ChannelItem] {
        return components
    }
}
