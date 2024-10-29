//
//  BackgroundModifier.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial)
    }
}

extension View {
    func returnDefaultBackgroundView() -> some View {
        modifier(BackgroundModifier())
    }
}
