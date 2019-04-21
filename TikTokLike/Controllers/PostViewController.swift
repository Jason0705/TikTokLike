//
//  PostViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-21.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostViewController: UIViewController {

    // MARK: - Constants & Variables
    
    var videoURL: URL!
    var uid: String!
    
    var pause = false
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var audioButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playControl()
    }
    
    
    // MARK: - Functions
    
    func setUp() {
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.frame.width
        
        VideoService.createAVPlayerLayer(on: videoView, with: videoURL!)
        VideoService.player.isMuted = true
        
        getUserProfilePhoto()
    }
    
    
    func getUserProfilePhoto() {
        UserService.getUserOnce(with: uid) { (user, error) in
            if error != nil {
                print(error)
            }
            else if user != nil {
                if let profilePhotoURL = user?.profile_photo_url {
                    self.profileImageView.image = ImageService.getImageUsingCacheWithURL(urlString: profilePhotoURL)
                }
            }
        }
    }
    
    
    func playControl() {
        if videoURL != nil {
            switch pause  {
            case false:
                pause = true
                VideoService.player.pause()
                SVProgressHUD.show(UIImage(named: "pause")!, status: nil)
                SVProgressHUD.dismiss(withDelay: 1)
                
            case true:
                pause = false
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
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if VideoService.player != nil {
            VideoService.player.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func audioButtonPressed(_ sender: UIButton) {
        audioControl()
    }
    
}

