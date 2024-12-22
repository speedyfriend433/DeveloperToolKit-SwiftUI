//
//  FormatterActionButton.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct FormatterActionButton: View {
    let title: String
    let icon: String
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(.callout, design: .rounded, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.3), radius: 5, x: 0, y: 2)
            )
        }
    }
}
