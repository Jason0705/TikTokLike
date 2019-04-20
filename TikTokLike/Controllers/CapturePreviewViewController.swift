//
//  CapturePreviewViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

class CapturePreviewViewController: UIViewController {
    
    // MARK: - Variables
    
    var from = 0 // 0: from EditProfileVC, 1: from NewPostVC
    
    var photo: UIImage!
    var videoURL: URL!
    
    var pause = 0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var audioButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPreview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playControl()
    }
    
    // MARK: - Functions
    
    func showPreview() {
        if photo != nil { // show photo
            previewImageView.isHidden = false
            audioButton.isHidden = true
            previewImageView.image = photo
        }
        else if videoURL != nil { // show video
            previewImageView.isHidden = true
            audioButton.isHidden = false
            VideoService.createAVPlayerLayer(on: previewView, with: videoURL!)
            VideoService.player.isMuted = true
        }
    }
    
    func playControl() {
        if videoURL != nil {
            switch pause  {
            case 0:
                pause = 1
                VideoService.player.pause()
                SVProgressHUD.show(UIImage(named: "pause")!, status: nil)
                SVProgressHUD.dismiss(withDelay: 1)
                
            case 1:
                pause = 0
                VideoService.player.play()
                SVProgressHUD.show(UIImage(named: "play")!, status: nil)
                SVProgressHUD.dismiss(withDelay: 1)
                
            default:
                break
            }
        }
    }
    
    func audioControl() {
        if videoURL != nil {
            if audioButton.tag == 0 { // audio off
                audioButton.tag = 1
                VideoService.player.isMuted = false
                audioButton.setImage(UIImage(named: "audio_on"), for: .normal)
            }
            else if audioButton.tag == 1 { // audio on
                audioButton.tag = 0
                VideoService.player.isMuted = true
                audioButton.setImage(UIImage(named: "audio_off"), for: .normal)
            }
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
        if VideoService.player != nil {
            VideoService.player.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        if VideoService.player != nil {
            VideoService.player.pause()
        }
        
        if from == 0 {
            performSegue(withIdentifier: "unwind", sender: nil)
        }
        else if from == 1 {
            
        }
        
        //        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func audioButtonPressed(_ sender: UIButton) {
        audioControl()
    }
    
    
}

