//
//  EditProfileViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class EditProfileViewController: UIViewController {

    // MARK: - Constants & Variables
    
    struct userInfo {
        var icon: UIImage?
        var content: String?
        var placeholder: String?
    }
    
    var infoData = [userInfo]()
    
    var selectedIndexPath = IndexPath()
    
    var selectedProfilePhoto: UIImage?
    
    
    var imagePicker = UIImagePickerController()
    
    
    // MARK: - UIOutlets
    
    @IBOutlet weak var editProfileTableView: UITableView!
    
    @IBOutlet weak var doneButtonView: UIView!
    @IBOutlet weak var doneButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // imagePicker delegate
        imagePicker.delegate = self
        
        // Register Cell.xib
        editProfileTableView.register(UINib(nibName: "ImageTableCell", bundle: nil), forCellReuseIdentifier: "imageTableCell")
        editProfileTableView.register(UINib(nibName: "InputTableCell", bundle: nil), forCellReuseIdentifier: "inputTableCell")
        
        populateInfoData()
        
        setUp()
    }
    
    
    // MARK: - Functions
    
    // UI Set Up
    
    func setUp() {
        doneButtonViewHeight.constant = 0
        doneButton.isHidden = true
        
        UserService.getUserOnce(with: UserService.getCurrentUserID()) { (user, error) in
            if error != nil {
                print("\(error)")
            }
            else if user != nil {
                
                if let profilePhotoURL = user?.profile_photo_url {
                    self.selectedProfilePhoto = ImageService.getImageUsingCacheWithURL(urlString: profilePhotoURL)
                }
                
                if let userName = user?.user_name {
                    self.infoData[0].content = userName
                }
                
                if let bio = user?.bio {
                    self.infoData[1].content = bio
                }
                
                self.editProfileTableView.reloadData()
            }
        }
    }
    
    func populateInfoData() {
        infoData.removeAll()
        infoData.append(userInfo(icon: UIImage(named: "person_outline"), content: "", placeholder: "User Name"))
        infoData.append(userInfo(icon: UIImage(named: "edit_outline"), content: "", placeholder: "Bio"))
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
                self.doneButtonViewHeight.constant = 258 + 44 + 44 // keyboard height + sugest text view height + visable dont button view height
                self.doneButton.isHidden = false
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    // Pick Profile Photo
    func handleSelectProfilePhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        let storyboard = UIStoryboard(name: "CustomCamera", bundle: nil)
        let customCameraVC = storyboard.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraViewController
        customCameraVC.captureMode = 0
        self.present(customCameraVC, animated: true, completion: nil)
    }
    
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func saveProfile() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        
        let uid = UserService.getCurrentUserID()
        let databaseReference = Database.database().reference()
        let storageReference = Storage.storage().reference()
        let userReference = databaseReference.child("users").child(uid)
        let profilePhotoReference = storageReference.child("profile_images").child("\(uid).jpg")
        
        if let profilePhoto = selectedProfilePhoto, let imageData = profilePhoto.jpegData(compressionQuality: 0.1) {
            profilePhotoReference.putData(imageData, metadata: nil) { (storageMetadata, error) in
                if error != nil { // error
                    print("Save profile photo error: \(error!)")
                    SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                    SVProgressHUD.dismiss(withDelay: 2)
                    return
                }
                // no error
                profilePhotoReference.downloadURL(completion: { (url, error) in
                    if error != nil { // error
                        print("Get profile photo URL error: \(error!)")
                        SVProgressHUD.showError(withStatus: "Sorry, ther has been an error. Please try again later.")
                        SVProgressHUD.dismiss(withDelay: 2)
                        return
                    }
                    // no error
                    let profilePhotoURL = url?.absoluteString
                    userReference.child("/profile_photo_url").setValue(profilePhotoURL)
                })
            }
        }
        
        userReference.child("user_name").setValue(infoData[0].content)
        userReference.child("bio").setValue(infoData[1].content)
        
        SVProgressHUD.showSuccess(withStatus: "Changes Saved")
        SVProgressHUD.dismiss(withDelay: 1)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UIActions
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        doneButtonViewState(state: 0)
        saveProfile()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        doneButtonViewState(state: 0)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        if let origin = segue.source as? CapturePreviewViewController {
            if origin.photo != nil {
                selectedProfilePhoto = origin.photo
            }
            
            editProfileTableView.reloadData()
        }
    }
    

}


// MARK: - UITableView Delegate & DataSource

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return infoData.count
            
        default:
            break
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageTableCell", for: indexPath) as! ImageTableCell
            
            cell.profileImageView.image = selectedProfilePhoto
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputTableCell", for: indexPath) as! InputTableCell
            
            cell.delegate = self
            
            cell.iconImageView.image = infoData[indexPath.row].icon
            cell.contentTextView.text = infoData[indexPath.row].content
            cell.placeholderLabel.text = infoData[indexPath.row].placeholder
            
            if !infoData[indexPath.row].content!.isEmpty {
                cell.placeholderLabel.isHidden = true
            }
            else {
                cell.placeholderLabel.isHidden = false
            }
            
            return cell
            
        default:
            break
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "inputTableCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        switch indexPath.section {
        case 0:
            doneButtonViewState(state: 0)
            handleSelectProfilePhoto()
            
        case 1:
            doneButtonViewState(state: 1)
            if let cell = editProfileTableView.cellForRow(at: indexPath) as? InputTableCell {
                cell.contentTextView.becomeFirstResponder()
            }
            
        default:
            break
        }
    }
    
    
}


// MARK: - UI Image Picker Delegation

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedProfilePhoto = editedImage
        }
        dismiss(animated: true, completion: nil)
        editProfileTableView.reloadData()
    }
}


// MARK: - InputTableCell Protocol

extension EditProfileViewController: InputTableCellProtocol {
    func infoCellContentReceived(content: String) {
        infoData[selectedIndexPath.row].content = content
    }
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        editProfileTableView.beginUpdates()
        editProfileTableView.endUpdates()
        editProfileTableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
    
}
