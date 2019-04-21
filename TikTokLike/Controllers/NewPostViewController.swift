//
//  NewPostViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-20.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD


class NewPostViewController: UIViewController {
    
    
    // Variables
    
    let defaults = UserDefaults.standard
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var selectedVideoURL: URL? // save to firebase/storage
    var caption = "" // save to firebase/storage
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newPostTableView: UITableView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell.xib
        newPostTableView.register(UINib(nibName: "VideoTableCell", bundle: nil), forCellReuseIdentifier: "videoTableCell")
        newPostTableView.register(UINib(nibName: "InputTableCell", bundle: nil), forCellReuseIdentifier: "inputTableCell")
        
        // Set UI State
        setUp()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButtonViewState(state: 0)
    }
    
    
    // MARK: - Functions
    
    func setUp() {
        doneButtonViewHeight.constant = 0
        doneButton.isHidden = true
        newPostTableView.separatorStyle = .none
        
        updateShareBarButton()
        
        newPostTableView.reloadData()
    }
    
    func updateShareBarButton() {
        if selectedVideoURL != nil {
            shareBarButton.isEnabled = true
        }
        else {
            shareBarButton.isEnabled = false
        }
    }
    
    func doneButtonViewState(state: Int){
        UIView.animate(withDuration: 0.225) {
            // close state
            if state == 0 {
                self.doneButtonViewHeight.constant = 0
                self.doneButton.isHidden = true
                self.view.endEditing(true)
            }
                
                // keyboard editing state
            else if state == 1 {
                self.doneButtonViewHeight.constant = 258 + 44 + 44 // keyboard height + suggested text view height + visable dont button view height
                self.doneButton.isHidden = false
            }
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    func handleCancelPost() {
        let alert = UIAlertController(title: "If you go back now, yor post will be discarded.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
            if VideoService.player != nil {
                VideoService.player.pause()
            }
            self.selectedVideoURL = nil
            self.caption = ""
            self.newPostTableView.reloadData()
            self.updateShareBarButton()
            //            self.defaults.set(0, forKey: "NewPostSaved")
            //self.tabBarController?.selectedIndex = self.defaults.integer(forKey: "SelectedTabBar")
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func savePost() {
        
        if Auth.auth().currentUser != nil { // user signed in
            
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.none)
            
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let databaseRefernce = Database.database().reference()
            let storageReference = Storage.storage().reference()
            
            let postReference = databaseRefernce.child("posts")
            let newPostID = postReference.childByAutoId().key
            let newPostReference = postReference.child(newPostID!)
            
            let imageVideoID = NSUUID().uuidString
            let imageReference = storageReference.child("posts").child(newPostID!).child("\(imageVideoID).jpg")
            let videoReference = storageReference.child("posts").child(newPostID!).child("\(imageVideoID).mp4")
            
            // save video
            if selectedVideoURL != nil {
                videoReference.putFile(from: selectedVideoURL!, metadata: nil) { (storageMetadata, error) in
                    if error != nil { // error
                        print("Save profile photo error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    videoReference.downloadURL(completion: { (url, error) in
                        if error != nil { // error
                            print("Get profile photo URL error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                            SVProgressHUD.dismiss(withDelay: 2)
                            return
                        }
                        // no error
                        let postVideoURL = url?.absoluteString
                        newPostReference.child("/video_url").setValue(postVideoURL)
                    })
                }
                // save video thumbnail
                let imageData = VideoService.createVideoThumbnail(with: selectedVideoURL!)?.jpegData(compressionQuality: 0.1)
                imageReference.putData(imageData!, metadata: nil) { (storageMetadata, error) in
                    if error != nil { // error
                        print("Save profile photo error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    imageReference.downloadURL(completion: { (url, error) in
                        if error != nil { // error
                            print("Get profile photo URL error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
                            SVProgressHUD.dismiss(withDelay: 2)
                            return
                        }
                        // no error
                        let thumbnailURL = url?.absoluteString
                        newPostReference.child("/thumbnail_url").setValue(thumbnailURL)
                    })
                }
            }
            
            
            newPostReference.child("/caption").setValue(caption)
            newPostReference.child("/uid").setValue(uid)
            newPostReference.child("/post_id").setValue(newPostID)
            newPostReference.child("/timestamp").setValue(ServerValue.timestamp())
            
            SVProgressHUD.showSuccess(withStatus: "Post Shared")
            SVProgressHUD.dismiss(withDelay: 1)
            
            if VideoService.player != nil {
                VideoService.player.pause()
            }
            
            self.selectedVideoURL = nil
            self.caption = ""
            self.newPostTableView.reloadData()
            self.updateShareBarButton()
            //            self.defaults.set(1, forKey: "NewPostSaved")
            //self.tabBarController?.selectedIndex = self.defaults.integer(forKey: "SelectedTabBar")
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
            
        else { // user authentication error
            SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
            SVProgressHUD.dismiss(withDelay: 2)
        }
        
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        handleCancelPost()
    }
    
    @IBAction func shareBarButtonPressed(_ sender: Any) {
        savePost()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        doneButtonViewState(state: 0)
    }
    
    
}



// MARK: - Table View Delegate, Data Source

extension NewPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Populate Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoTableCell", for: indexPath) as! VideoTableCell
            cell.delegate = self
            
            if selectedVideoURL != nil {
                VideoService.createAVPlayerLayer(on: cell.videoPreviewView, with: selectedVideoURL!)
                VideoService.player.isMuted = true
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputTableCell", for: indexPath) as! InputTableCell
            
            cell.delegate = self
            cell.iconImageView.image = UIImage(named: "edit_outline")
            cell.placeholderLabel.text = "Write a caption..."
            
            if caption.isEmpty {
                cell.placeholderLabel.isHidden = false
                cell.contentTextView.text = ""
            }
            
            return cell
            
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "videoTableCell", for: indexPath)
    }
    
    // Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            doneButtonViewState(state: 0)
        }
        else if indexPath.section == 1 {
            doneButtonViewState(state: 1)
            if let cell = newPostTableView.cellForRow(at: indexPath) as? InputTableCell {
                cell.contentTextView.becomeFirstResponder()
            }
        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
}




// MARK: - Protocols

// Update Custom cell
extension NewPostViewController: InputTableCellProtocol {
    func infoCellContentReceived(content: String) {
        caption = content
        updateShareBarButton()
    }
    
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        newPostTableView.beginUpdates()
        newPostTableView.endUpdates()
        newPostTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
}


extension NewPostViewController: VideoTableCellProtocal {
    func audioOn() {
        if selectedVideoURL != nil {
            VideoService.player.isMuted = false
        }
    }
    
    func audioOff() {
        if selectedVideoURL != nil {
            VideoService.player.isMuted = true
        }
    }
    
}
