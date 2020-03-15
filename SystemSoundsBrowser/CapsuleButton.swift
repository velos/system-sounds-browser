//
//  ButtonUI.swift
//  SoundAndHapticsService
//
//  Created by Weili Kuo on 3/12/20.
//  Copyright © 2020 Velos Mobile LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct CapsuleButton: View {
    
    let button: AnyView

    init(_ title: String, action: @escaping () -> Void) {
        button = AnyView(
            Button(action: action, label: { CapsuleButton.baseContent(title) })
        )
    }
    
    init(_ title: String, action: @escaping () -> Void, doubleTapAction: @escaping () -> Void) {
        let tapGesture = TapGesture().onEnded { _ in action() }
        let doubleTapGesture = TapGesture(count: 2).onEnded { _ in doubleTapAction() }
        button = AnyView(
            CapsuleButton.baseContent(title)
                .gesture(tapGesture.simultaneously(with: doubleTapGesture))
        )
    }

    var body: some View {
        button
    }

    // MARK: Private
    private static func baseContent(_ title: String) -> AnyView {
        AnyView(Capsule()
            .foregroundColor(Color("contentBackground"))
            .frame(height: 50)
            .overlay(Text(title)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center))
        )
    }

}
