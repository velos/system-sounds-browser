//
//  Favorite.swift
//  SystemSoundsBrowser
//
//  Created by Weili Kuo on 3/15/20.
//  Copyright © 2020 Velos Mobile LLC. All rights reserved.
//

import SwiftUI
import AudioToolbox

struct Favorite: Hashable {
    var id: String { "\(soundID) - \(hapticsIndex)"}
    let soundID: SystemSoundID
    let hapticsIndex: Int
}

struct FavoriteButton: View {
    var favorites: [Favorite]
    var index: Int
    @Binding var selectedFavorite: Int?
    @Binding var showActionSheet: Bool
    
    var body: some View {
        let favorite = favorites[index]
        return CapsuleButton("\(favorite.soundID)\(favorite.hapticsIndex == 0 ? "" : "\n\(Haptics.names[favorite.hapticsIndex]!)")",
            action: {
                service.play(.systemSound(favorite.soundID))
                service.play(.hapticsFile(Haptics.names[favorite.hapticsIndex]))
        }, doubleTapAction: {
            self.selectedFavorite = self.index
            self.showActionSheet = true
        })
        .font(.system(size: 12)).padding([.leading, .trailing], 5)
    }
}
