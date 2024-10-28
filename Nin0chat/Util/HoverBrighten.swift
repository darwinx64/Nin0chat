//
//  HoverBrighten.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//

import SwiftUI

struct HoverBrighten: ViewModifier {
    @State var isHovered = false
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(isHovered ? .primary : .secondary)
            .onHover(perform: { inside in
                isHovered = inside
            })
    }
}

extension View {
    func hoverBrighten() -> some View {
        self.modifier(HoverBrighten())
    }
}
