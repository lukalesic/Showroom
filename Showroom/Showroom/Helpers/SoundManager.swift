//
//  SoundManager.swift
//  Showroom
//
//  Created by Luka Lešić on 27.03.2024..
//

import Foundation
import AVFAudio

@Observable
class SoundManager {
    var player: AVAudioPlayer?
    
    static let shared = SoundManager()
    
    private init() {}
    
    func playSound(soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print("Failed to load the sound: \(error)")
        }
        player?.play()
    }
}
