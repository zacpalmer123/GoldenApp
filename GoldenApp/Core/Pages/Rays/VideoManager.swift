//
//  VideoManager.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 10/2/25.
//

import Combine
import AVKit
class VideoPlayerManager: ObservableObject {
    @Published var player: AVPlayer? = nil
    
    func load(url: URL) {
        if player?.currentItem?.asset != AVAsset(url: url) {
            let newPlayer = AVPlayer(url: url)
            newPlayer.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                   object: newPlayer.currentItem,
                                                   queue: .main) { _ in
                newPlayer.seek(to: .zero)
                newPlayer.play()
            }
            
            player = newPlayer
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
}

