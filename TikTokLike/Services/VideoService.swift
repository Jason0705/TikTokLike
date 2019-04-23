//
//  VideoService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import AVFoundation

let playerCache = NSCache<AnyObject, AnyObject>()

class VideoService {
    
    static var player: AVPlayer!
    
    
    // MARK: - Create Video Player Layer
    static func createAVPlayerLayer(on view: UIView, with url: URL) {
        player = AVPlayer(url: url)
        player.automaticallyWaitsToMinimizeStalling = false
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    static func createVideoThumbnail(with videoURL: URL) -> UIImage? {
        
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 600)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: timestamp, actualTime: nil)
            let thumbnail = UIImage(cgImage: imageRef)
            return thumbnail
        } catch {
            print("Image generation failed with error \(error.localizedDescription)")
            return nil
        }
    }
    
}

