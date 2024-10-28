//
//  ContentView.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var showingInspector: Bool = true

    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var websocket: Websocket = Websocket()

    @State public var text: String = "Type here"

    var body: some View {
        NavigationSplitView {
            ChannelListView()
                .frame(minWidth: 170)
                .disabled(websocket.socketFailed)
                .grayscale(websocket.socketFailed ? 1 : 0)
                .opacity(websocket.socketFailed ? 0.5 : 1)
                .animation(.spring(.bouncy), value: websocket.socketFailed)
        } detail: {
            if !websocket.socketFailed {
                Text("Nop")
                ScrollViewReader { scrollView in
                    List(websocket.messages, id: \.self) { message in
                        MessageView(message: message)
                    }
                    .onChange(of: websocket.messages,  {
                        if websocket.messages.count > 0 {
                            scrollView.scrollTo(websocket.messages[websocket.messages.endIndex - 1])
                        }
                    })
                }
            } else {
                ContentUnavailableView {
                    Label("Connection Issue", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(websocket.error)
                } actions: {
                    Button("Refresh") {
                        websocket.socketFailed = false
                        websocket.connect()
                    }
                    .buttonStyle(.link)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding([.leading, .top, .bottom])
                }
                .help("Upload an image to Catbox, only images supported")
#if os(macOS)
                .onHover { inside in
                    if !websocket.socketFailed {
                        if inside {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                }
#endif
                .hoverBrighten()
                .contentShape(Rectangle())
                .catboxUploader($text)
                .disabled(websocket.socketFailed)
                .opacity(websocket.socketFailed ? 0.2 : 1)
                .animation(.spring(.bouncy), value: websocket.socketFailed)
                ZStack(alignment: .trailing) {
                    TextEditingView(text: $text)
                        .disabled(websocket.socketFailed)
                        .opacity(websocket.socketFailed ? 0.2 : 1)
                    if (!text.isEmpty && text != "Type here" && !websocket.socketFailed) {
                        Button { websocket.sendChatMessage(content: text) } label: {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .scaledToFit()
                                .padding([.trailing, .top, .bottom])
                                .frame(width: 16, height: 16)
                        }
#if os(macOS)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
#endif
                        .buttonStyle(.borderless)
                        .transition(.symbolEffect(.disappear))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(.bar)
                    .stroke(.gray.opacity(colorScheme == .dark ? 0.4 : 0), lineWidth: 1)
                    .opacity(websocket.socketFailed ? 0.2 : 1)
                    .animation(.spring(.bouncy), value: websocket.socketFailed)
            )
            .shadow(radius: colorScheme == .dark ? 0 : 2)
            .padding([.horizontal, .bottom], 12)
            .frame(minHeight: 90)
        }
        .navigationTitle("nin0chat")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Image(systemName: "number")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .inspector(isPresented: $showingInspector) {
            List(websocket.users, id: \.self) { user in
                Text(user.username)
                    .onTapGesture(perform: {
#if os(macOS)
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(user.id, forType: .string)
#else
                        UIPasteboard.general.setValue(user.id, forPasteboardType: UTType.plainText.identifier)
#endif
                    })
            }
            .listStyle(.sidebar)
            .inspectorColumnWidth(min: 150, ideal: 150, max: 500)
            .toolbar {
                Button(action: toggleInspector) {
                    Image(systemName: showingInspector ? "person.2.fill" : "person.2")
                }
                if showingInspector {
                    Text("Online - \(websocket.users.count)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    private func toggleInspector() {
        showingInspector.toggle()
    }
}

#Preview {
    ContentView()
        .frame(width: 920, height: 500)
        .navigationTitle("nin0chat")
}
