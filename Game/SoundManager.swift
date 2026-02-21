//
//  SoundManager.swift
//  Game
//
//  Created by 仔室宗亲 on 18/2/26.
//

import AVFoundation

class SoundManager{
    static let shared = SoundManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var soundEffectPlayer: AVAudioPlayer?
    
    private init() {} // 防止多个instances
    
    func playBackgroundMusic(fileName: String, loop: Bool = true){
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else{
            print("未找到BGM \(fileName).mp3")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = loop ? -1 : 0
            backgroundMusicPlayer?.volume = 0.1
            backgroundMusicPlayer?.play()
        } catch {
            print("error could not play BGM")
        }
    }
    
    func stopBackgroundMusic(){
        backgroundMusicPlayer?.stop()
    }
    
    func playSoundEffect(fileName: String){
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else{
            print("未找到BGM \(fileName).mp3")
            return
        }
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.play()
        } catch {
            print("error could not play sound effect")
        }
    }
    
}
