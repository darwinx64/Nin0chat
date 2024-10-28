//
//  ViewHeightKey.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
