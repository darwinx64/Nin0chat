//
//  MessageType.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

struct MessageType {
    static let Normal: Int      = 0
    static let Join: Int        = 1
    static let Leave: Int       = 2
    static let GoodPerson: Int  = 3
    static let Bridge: Int      = 4
    static func from(_ string: String?) -> Int? {
        guard let string = string else { return nil }
        switch string {
        case "Normal":
            return MessageType.Normal
        case "Join":
            return MessageType.Join
        case "Leave":
            return MessageType.Leave
        case "GoodPerson":
            return MessageType.GoodPerson
        case "Bridge":
            return MessageType.Bridge
        default:
            return nil
        }
    }
}
