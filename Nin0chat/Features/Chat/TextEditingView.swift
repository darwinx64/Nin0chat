//
//  TextEditingView.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//

import SwiftUI

struct TextEditingView: View {
    @Binding public var text: String
    @FocusState private var isFocused: Bool
    @State var textEditorHeight : CGFloat = 40

    var body: some View {
        ZStack(alignment: .leading) {
            Text(text)
                .font(.system(.body))
                .foregroundColor(.clear)
                .padding(0)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            TextEditor(text: $text)
                .foregroundColor(self.text == "Type here" ? .gray : .primary)
                .focused($isFocused)
                .onChange(of: isFocused) {
                    switch isFocused {
                    case true:
                        if text == "Type here" {
                            text = ""
                        }
                        break
                    case false:
                        if text == "" {
                            text = ""
                        }
                        break
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(text.numberOfLines == 1)
                .padding(.leading, 5)
                .font(.system(.body))
                .frame(height: max(0,textEditorHeight))
                .cornerRadius(9)
                .lineSpacing(5)
            
        }
        .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
    }
}
