//
//  KeyboardToolbar.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI
import UIKit

struct KeyboardToolbar: ViewModifier {
    let title: String
    @FocusState private var isFocused: Bool
    
    init(title: String = "Done") {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(title) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                     to: nil,
                                                     from: nil,
                                                     for: nil)
                    }
                }
            }
    }
}

extension View {
    func addKeyboardToolbar(title: String = "Done") -> some View {
        modifier(KeyboardToolbar(title: title))
    }
}
