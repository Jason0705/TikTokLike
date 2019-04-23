//
//  ChatViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-22.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ChameleonFramework

class ChatViewController: UIViewController {

    // Constatns & Variables
    
    let selfUID = UserService.getCurrentUserID()
    
    var uid: String?
    
    var messages = [Message]()
    
    
    // MARK: - UIOutlets
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendViewHeight: NSLayoutConstraint!
    
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell.xib
        chatTableView.register(UINib(nibName: "MessageTableCell", bundle: nil), forCellReuseIdentifier: "messageTableCell")
        
        setUp()
    }
    
    // MARK: Functions
    
    // UI Set Up
    func setUp() {
        
        UserService.getUserOnce(with: uid!) { (user, error) in
            if error != nil {
                print("Get User Error: \(error)")
            }
            else if user != nil {
                self.navigationItem.title = user!.user_name // change navbar title to userName
            }
        }
        
        // Add tab gesture to table view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        chatTableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        fetchMessages()
    }
    
    
    func fetchMessages() {
        Database.database().reference().child("messages").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let sender = dictionary["sender"]
                let receiver = dictionary["receiver"]
                let text = dictionary["text"]
                
                if (sender == self.selfUID && receiver == self.uid) || (sender == self.uid && receiver == self.selfUID) {
                    
                    let message = Message()
                    message.sender = sender
                    message.receiver = receiver
                    message.text = text
                    
                    self.messages.append(message)
                    
                    self.configureTableView()
                    self.chatTableView.reloadData()
                    
                }
                
            }
        }
    }
    
    func configureTableView() {
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 120.0
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    
    
    // Mark: UIActions
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if messageTextField.text != "" {
            messageTextField.endEditing(true)
            
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            
            let messageDict = ["sender" : selfUID,
                               "receiver" : uid!,
                               "text" : messageTextField.text] as [String : Any]
            
            Database.database().reference().child("messages").childByAutoId().setValue(messageDict) {
                (error, reference) in
                if error != nil {
                    print(error!)
                }
                else {
                    self.messageTextField.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextField.text = ""
                }
            }
        }
        
    }
    

}


// MARK: - UITableView Delegate & DataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableCell", for: indexPath) as! MessageTableCell
        
        if let sender = messages[indexPath.row].sender {
            UserService.getUserOnce(with: sender) { (user, error) in
                if error != nil {
                    print(error)
                }
                else if user != nil {
                    cell.senderProfileImageView.image = ImageService.getImageUsingCacheWithURL(urlString: user!.profile_photo_url!)
                    
                    cell.senderUserNameLabel.text = user?.user_name
                }
            }
            
            if sender == selfUID {
                // Message sent by self
                cell.messageBackgroundView.backgroundColor = UIColor.flatSkyBlue
            }
            else {
                // Message sent by others
                cell.messageBackgroundView.backgroundColor = UIColor.flatSand
            }
            
        }
        let receiver = messages[indexPath.row].receiver
        if let text = messages[indexPath.row].text {
            cell.messageTextLabel.text = text
        }
        
        return cell
    }
    
    
}


// MARK: - UITextField Delegate

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.225) {
            self.sendViewHeight.constant = 258 + 44 + 44
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.225) {
            self.sendViewHeight.constant = 44
            self.view.layoutIfNeeded()
        }
    }
    
    
}



