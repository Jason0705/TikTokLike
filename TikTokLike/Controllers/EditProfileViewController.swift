//
//  EditProfileViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    // MARK: - Constants & Variables
    
    var selectedProfilePhoto: UIImage?
    
    
    var imagePicker = UIImagePickerController()
    
    
    // MARK: - UIOutlets
    
    @IBOutlet weak var editProfileTableView: UITableView!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // imagePicker delegate
        imagePicker.delegate = self
        
        // Register Cell.xib
        editProfileTableView.register(UINib(nibName: "ImageTableCell", bundle: nil), forCellReuseIdentifier: "imageTableCell")
        editProfileTableView.register(UINib(nibName: "InputTableCell", bundle: nil), forCellReuseIdentifier: "inputTableCell")
        
    }
    
    
    // MARK: - Functions
    
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
    
    
    // MARK: - UIActions
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
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
            return 2
            
        default:
            break
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageTableCell", for: indexPath) as! ImageTableCell
            
            cell.profileImageView.layer.cornerRadius = 0.5 * cell.profileImageView.frame.width
            cell.profileImageView.image = selectedProfilePhoto
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputTableCell", for: indexPath) as! InputTableCell
            
            return cell
            
        default:
            break
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "inputTableCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            handleSelectProfilePhoto()
            
        case 1:
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
