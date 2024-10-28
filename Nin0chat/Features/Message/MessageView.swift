//
//  MessageView.swift
//  Nin0chat
//
//  Created by tiramisu on 10/24/24.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            roleBadge(for: message.author)

            if message.author.roles != Role.System {
                Text(message.author.username)
                    .fontWeight(.bold)
                    .foregroundColor(color(for: message.author))
            }

            Text(message.content)
                .italic(message.author.roles == Role.System)
        }
        .padding()
        .background(message.author.roles == Role.System ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }

    private func color(for user: User) -> Color {
        if let roles = user.roles {
            switch roles {
            case Role.Admin:
                return .red
            case Role.Mod:
                return .green
            case Role.Bot:
                return .blue
            default:
                return .secondary
            }
        }
        return .black
    }

    private func roleBadge(for user: User) -> some View {
        Group {
            if let roles = user.roles {
                switch roles {
                case Role.Guest:
                    Text("Guest")
                        .font(.caption)
                        .padding(4)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Capsule())
                case Role.Mod:
                    Text("Mod")
                        .font(.caption)
                        .padding(4)
                        .background(Color.green.opacity(0.3))
                        .clipShape(Capsule())
                case Role.Admin:
                    Text("Admin")
                        .font(.caption)
                        .padding(4)
                        .background(Color.red.opacity(0.3))
                        .clipShape(Capsule())
                case Role.Bot:
                    Text("Bot")
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue.opacity(0.3))
                        .clipShape(Capsule())
                case Role.System:
                    EmptyView()
                default:
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
    }
}
