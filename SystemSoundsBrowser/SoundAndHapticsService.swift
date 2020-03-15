//
//  SoundAndHapticsService.swift
//  SoundAndHapticsService
//
//  Created by Weili Kuo on 3/12/20.
//  Copyright © 2020 Velos Mobile LLC. All rights reserved.
//

import Foundation
import CoreHaptics
import AudioToolbox

enum SoundAndHaptics {
    /// Light tap with system keyboard sound
    case keyPress
    /// Same haptics as keyPress, but without audio.
    case lightTap
    /// Similar to sound and haptics used by the system Clock app
    case sliderClick
    /// Upbeat sounding chime with haptics
    case successChimeDualTone
    /// Upbeat sounding chime with haptics
    case successChimeTripleTone
    /// A light rattle without audio
    case lightRattle
    /// Artibrary system sound identified by provided SystemSoundID
    case systemSound(SystemSoundID)
    /// Arbitrary haptics file (.ahap) identified by provided filename (base component without file extension)
    case hapticsFile(String?)
}

protocol SoundAndHapticsServiceType {
    var supportsHaptics: Bool { get }
    var supportsAudio: Bool { get }
    func play(_ soundAndHaptics: SoundAndHaptics)
}

class SoundAndHapticsService: SoundAndHapticsServiceType {
    public let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    public let supportsAudio = CHHapticEngine.capabilitiesForHardware().supportsAudio
    
    func play(_ soundAndHaptics: SoundAndHaptics) {
        switch soundAndHaptics {
        case .keyPress:
            AudioServicesPlaySystemSound(1155)
            playHapticsFile("lightTap")

        case .lightTap:
            playHapticsFile("lightTap")
            
        case .sliderClick:
            AudioServicesPlaySystemSound(1157)
            playHapticsFile("lightClick")

        case .successChimeDualTone:
            AudioServicesPlaySystemSound(1394)

        case .successChimeTripleTone:
            AudioServicesPlaySystemSound(1262)

        case .lightRattle:
            AudioServicesPlaySystemSound(1521)
            
        case .systemSound(let soundID):
            AudioServicesPlaySystemSound(soundID)
            
        case .hapticsFile(let filename):
            guard let filename = filename else { return }
            playHapticsFile(filename)
        }
    }
    
    init() {
        engine = try? CHHapticEngine()
        engine?.stoppedHandler = { [weak self] _ in
            self?.hasEngineStarted = false
        }
        startEngineIfNeeded()
    }

    // MARK: Private

    private let engine: CHHapticEngine?
    private var hasEngineStarted: Bool = false
    
    @discardableResult private func startEngineIfNeeded() -> Bool {
        guard !hasEngineStarted, let engine = engine else { return hasEngineStarted }
        
        do {
            try engine.start()
            hasEngineStarted = true
            return true
        } catch {
            print("Unable to start haptics engine")
            return false
        }
    }
    
    private func playHapticsFile(_ filename: String) {
        guard supportsHaptics, let path = Bundle.main.path(forResource: filename, ofType: "ahap"), startEngineIfNeeded() else { return }
        try? engine?.playPattern(from: URL(fileURLWithPath: path))
    }
    
}
