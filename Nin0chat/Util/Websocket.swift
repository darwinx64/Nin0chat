//
//  Websocket.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//

import SwiftUI
import Starscream

/// https://github.com/nin0chat/docs/wiki/Gateway
class Websocket: ObservableObject, WebSocketDelegate {
    @Published var messages = [Message]()
    @Published var error: String = ""
    @Published var users = [User]()
    @Published var socketFailed: Bool = false
    
    @AppStorage("customWsHost") var customWsHost = SettingsDefaults.customWsHost
    
    private var socket: WebSocket?

    init() {
        self.connect()
    }
    
    // MARK: - Connect
    func connect() {
        guard let url = URL(string: customWsHost) else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    // MARK: - WebSocketDelegate methods
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            self.loginAsGuest()
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            handleError(reason)
        case .text(let text):
            handleIncomingMessage(text)
        case .binary(let data):
            print("Received data: \(data)")
        case .error(let error):
            if let error = error {
                handleError(error)
            }
        case .cancelled:
            print("WebSocket connection cancelled")
        default:
            break
        }
    }
    
    // MARK: - Send heartbeat
    private func sendHeartbeat() {
        let heartbeat: [String: Any] = ["op": 2, "d": [:]]
        sendMessage(heartbeat)
    }
    
    // MARK: - Login
    private func loginAsGuest() {
        let loginData: [String: Any] = [
            "op": 1,
            "d": [
                "anon": true,
                "username": "swiftie",
                "device": "web"
            ]
        ]
        sendMessage(loginData)
    }
    
    // MARK: - Handle incoming message
    private func handleIncomingMessage(_ text: String) {
        guard let jsonData = text.data(using: .utf8) else { return }
        do {
            if let message = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let op = message["op"] as? Int,
               let data = message["d"] as? [String: Any] {
                switch op {
                case 0: // chat message
                    if let userInfo = data["userInfo"] as? [String: Any],
                       let username = userInfo["username"] as? String,
                       let id = userInfo["id"] as? String,
                       let roles = userInfo["roles"] as? Int?,
                       let content = data["content"] as? String,
                       let type = data["type"] as? Int {
                        let user = User(username: username, id: id, roles: roles)
                        let message = Message(author: user, content: content, type: type)
                        DispatchQueue.main.async {
                            withAnimation(.spring(.bouncy)) {
                                self.messages.append(message)
                            }
                        }
                    }
                case 1: // login
                    if let username = data["username"] as? String {
                        DispatchQueue.main.async {
                            print("logged in as \(username)")
                        }
                    }
                case 2:
                    self.sendHeartbeat()
                case 3: // history
                    if let history = data["history"] as? [[String: Any]] {
                        for messageData in history {
                            if let userInfo = messageData["userInfo"] as? [String: Any],
                               let username = userInfo["username"] as? String,
                               let id = userInfo["id"] as? String,
                               let roles = userInfo["roles"] as? Int?,
                               let content = messageData["content"] as? String,
                               let type = messageData["type"] as? Int {
                                let user = User(username: username, id: id, roles: roles)
                                let message = Message(author: user, content: content, type: type)
                                DispatchQueue.main.async {
                                    withAnimation(.spring(.bouncy)) {
                                        self.messages.append(message)
                                    }
                                }
                            }
                        }
                    }
                case 4: // members
                    if let usersArray = data["users"] as? [[String: Any]] {
                        for userData in usersArray {
                            if let username = userData["username"] as? String,
                               let id = userData["id"] as? String,
                               let roles = userData["roles"] as? Int {
                                DispatchQueue.main.async {
                                    self.users.append(User(username: username, id: id, roles: roles))
                                }
                            }
                        }
                    }
                case -1: // error
                    if let errorMessage = data["message"] as? String {
                        DispatchQueue.main.async {
                            self.handleError(errorMessage)
                        }
                    }
                default:
                    print("unknown opcode: \(op)")
                }
            }
        } catch {
            print("failed to parse\n\(error)")
            self.handleError(error)
        }
    }
    
    // MARK: - Send message (non-chat)
    private func sendMessage(_ message: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: message, options: []) else { return }
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        socket?.write(string: jsonString)
    }
    
    // MARK: - Send chat message
    func sendChatMessage(content: String) {
        let messageData: [String: Any] = [
            "op": 0,
            "d": [
                "content": content
            ]
        ]
        sendMessage(messageData)
    }
    
    func handleError(_ error: Error) {
        print(error.localizedDescription)
        self.error = error.localizedDescription
        self.socketFailed = true
        explode()
    }
    
    func handleError(_ errorMessage: String) {
        print(errorMessage)
        self.error = errorMessage
        self.socketFailed = true
        explode()
    }

    func explode() {
        socket?.disconnect(closeCode: CloseCode.goingAway.rawValue)
    }
    
    deinit {
        explode()
    }
}
