//
//  ContentBackgroudModifier.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import SwiftUI

struct ContentBackgroudModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: UIColor.tertiarySystemBackground))
            .cornerRadius(12)
    }
}

extension View {
    func returnContentBackgroundModifier() -> some View {
        modifier(ContentBackgroudModifier())
    }
}
