//
//  PickerViews.swift
//  SystemSoundsBrowser
//
//  Created by Weili Kuo on 3/15/20.
//  Copyright © 2020 Velos Mobile LLC. All rights reserved.
//

import SwiftUI
import AudioToolbox

struct SoundPickerView: View {
    @Binding var soundID: SystemSoundID
    
    var body: some View {
        VStack {
            HStack {
                CapsuleButton("←") {
                    self.soundID -= 1
                }.font(.headline).frame(width: 90)
                
                VStack {
                    Text("\(soundID)").frame(minWidth: 150).font(.bigDigit)
                }
                CapsuleButton("→") {
                    self.soundID += 1
                }.font(.headline).frame(width: 90)
            }
            Text("system sound / haptics ID").font(.system(size: 12)).offset(x: 0, y: -12)
        }
    }
}

struct HapticsPickerView: View {
    @Binding var index: Int
    
    var body: some View {
        HStack {
            CapsuleButton("←") {
                self.index = max(self.index - 1, 0)
            }.font(.headline).frame(width: 90)
            
            VStack {
                Text("custom haptics file").font(.system(size: 12))
                Text("\(Haptics.names[index] ?? "(none)")").frame(minWidth: 150).font(.system(size: 15))
            }
            
            CapsuleButton("→") {
                self.index = min(self.index + 1, Haptics.names.count - 1)
            }.font(.headline).frame(width: 90)
        }
    }
}
