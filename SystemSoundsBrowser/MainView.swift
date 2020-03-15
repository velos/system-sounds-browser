//
//  MainView.swift
//  SystemSoundsBrowser
//
//  Created by Weili Kuo on 3/13/20.
//  Copyright © 2020 Velos Mobile LLC. All rights reserved.
//

import SwiftUI
import AudioToolbox

extension Font {
    static let bigDigit = Font.system(size: 30, weight: .medium, design: .monospaced)
    static let smallDigit = Font.system(size: 20, weight: .regular, design: .monospaced)
    static let navigation = Font.system(size: 50, weight: .medium, design: .default)
}

struct Haptics {
    static let names: [String?] = [
        nil,
        // custom
        "light click",
        "light tap",
        
        // from Apple's demo project "PlayingACustomHapticPatternFromAFile"
        "boing",
        "gravel",
        "inflate",
        "oscillate",
        "rumble",
        "sparkle"
    ]
}

let service = SoundAndHapticsService()

struct MainView: View {
    @State var sliderValue: CGFloat = 0
    @State var soundID: SystemSoundID = 1000
    @State var hapticsIndex: Int = 0
    @State var favorites = [Favorite]()
    @State var selectedFavorite: Int?
    @State var showActionSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            HapticsPickerView(index: $hapticsIndex)
            
            Text("+").font(.headline).padding([.top, .bottom], 20)

            SoundPickerView(soundID: $soundID)

            VStack(spacing: 15) {
                CapsuleButton("▶︎") {
                    service.play(.systemSound(self.soundID))
                    service.play(.hapticsFile(Haptics.names[self.hapticsIndex]))
                }

                CapsuleButton("▶︎") {
                    self.soundID += 1
                    service.play(.systemSound(self.soundID))
                    service.play(.hapticsFile(Haptics.names[self.hapticsIndex]))
                }.overlay(Text("→").offset(x: -30, y: 0))

                CapsuleButton("♥︎") {
                    let newFavorite = Favorite(soundID: self.soundID, hapticsIndex: self.hapticsIndex)
                    self.favorites.append(newFavorite)
                }
            }
            .font(.smallDigit)
            .padding([.top], 40)
            .padding([.leading, .trailing], 60)

            Spacer(minLength: 30)
            
            Slider(value: Binding(
                        get: { self.sliderValue },
                        set: { value in
                            guard value != self.sliderValue else { return }
                            self.sliderValue = value
                            service.play(.systemSound(self.soundID))
                            service.play(.hapticsFile(Haptics.names[self.hapticsIndex]))
                    }),
                   in: 0...20, step: 1.0,
                   onEditingChanged: {_ in}
            ).padding([.leading, .trailing], 20)
            
            Spacer(minLength: 30)

            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 0) {
                    VStack {
                        ForEach(0..<self.favorites.count, id: \.self) { index in
                            Group {
                                if index % 3 == 0 {
                                    FavoriteButton(favorites: self.favorites, index: index, selectedFavorite: self.$selectedFavorite, showActionSheet: self.$showActionSheet)
                                }
                            }
                        }
                        Spacer()
                    }
                    VStack {
                        ForEach(0..<self.favorites.count, id: \.self) { index in
                            Group {
                                if index % 3 == 1 {
                                    FavoriteButton(favorites: self.favorites, index: index, selectedFavorite: self.$selectedFavorite, showActionSheet: self.$showActionSheet)
                                }
                            }
                        }
                        Spacer()
                    }
                    VStack {
                        ForEach(0..<self.favorites.count, id: \.self) { index in
                            Group {
                                if index % 3 == 2 {
                                    FavoriteButton(favorites: self.favorites, index: index, selectedFavorite: self.$selectedFavorite, showActionSheet: self.$showActionSheet)
                                }
                            }
                        }
                        Spacer()
                    }
                }.frame(maxWidth: .infinity)
            }

            if favorites.count > 0 {
                Text("double-tap for options")
            }
        }
        .padding([.leading, .trailing], 30)
        .padding([.top, .bottom], 20)
        .edgesIgnoringSafeArea([.bottom])
        .actionSheet(isPresented: $showActionSheet) {
            let selectedFav = self.favorites[self.selectedFavorite!]
            let hapticsFile = Haptics.names[selectedFav.hapticsIndex]
            return ActionSheet(
                title: Text((hapticsFile == nil ? "" : "\(hapticsFile!) + ") + "sound ID \(selectedFav.soundID)"),
                message: nil,
                buttons: [
                    .default(Text("Remove"), action: {
                        self.favorites.remove(at: self.selectedFavorite!)
                    }),
                    .default(Text("Focus"), action: {
                        self.soundID = selectedFav.soundID
                        self.hapticsIndex = selectedFav.hapticsIndex
                    }),
                    .cancel()
            ])
        }
    }

}

#if DEBUG

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

#endif
