//
//  ChatViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 23/02/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

//static let cellIdentifier = "ReusableCell"
//static let cellNibName = "MessageCell"
//static let registerSegue = "RegisterToChat"
//static let loginSegue = "LoginToChat"
//
//struct BrandColors {
//    static let purple = "BrandPurple"
//    static let lightPurple = "BrandLightPurple"
//    static let blue = "BrandBlue"
//    static let lighBlue = "BrandLightBlue"
//}
//
//struct FStore {
//    static let collectionName = "messages"
//    static let senderField = "sender"
//    static let bodyField = "body"
//    static let dateField = "date"
//}


//class ChatViewController: UIViewController {
//    let db = Firestore.firestore()
//
//    var user: User?
//
//    @IBOutlet weak var messageTextField: UITextField!
//    @IBOutlet weak var tableView: UITableView!
//
//    var messages:[Message] = []
//    override func viewDidLoad() {
//        self.messages = []
//        print(Auth.auth().currentUser?.uid)
//        super.viewDidLoad()
//        tableView.dataSource = self
//         tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
//        loadMessages()
//        print("db is \(db)")
//        print(user?.userId)
//    }
//
//    func loadMessages() {
//
//        db.collection(K.FStore.collectionName)
//            .order(by: K.FStore.dateField)
//            .addSnapshotListener { (querySnapshot, error) in
//
//            self.messages = []
//
//            if let e = error {
//                print("There was an issue retrieving data from Firestore. \(e)")
//            } else {
//                if let snapshotDocuments = querySnapshot?.documents {
//                    for doc in snapshotDocuments {
//                        let data = doc.data()
//                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
//                            let newMessage = Message(sender: messageSender, body: messageBody)
//                            self.messages.append(newMessage)
//
//                            DispatchQueue.main.async {
//                                   self.tableView.reloadData()
//                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @IBAction func sendPressed(_ sender: Any) {
//        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
//            db.collection(K.FStore.collectionName).document(user!.userId).setData([
//                                   K.FStore.senderField: messageSender,
//                                   K.FStore.bodyField: messageBody,
//                                   K.FStore.dateField: Date().timeIntervalSince1970
//
//       //      print("Auth.auth().current user is \(Auth.auth().currentUser)")
//                   db.collection(K.FStore.collectionName).addDocument(data: [
//                       K.FStore.senderField: messageSender,
//                       K.FStore.bodyField: messageBody,
//                       K.FStore.dateField: Date().timeIntervalSince1970
//                   ]) { (error) in
//                       if let e = error {
//                           print("There was an issue saving data to firestore, \(e)")
//                       } else {
//                           print("Successfully saved data.")
//
//                           DispatchQueue.main.async {
//                                self.messageTextField.text = ""
//                           }
//                       }
//                   }
//               }
//    }
//}
//
//extension ChatViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let message = messages[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
//        cell.label.text = message.body
//
//        //This is a message from the current user.
//        if message.sender == Auth.auth().currentUser?.email {
//            cell.leftImageView.isHidden = true
//            cell.rightImageView.isHidden = false
//            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
//            cell.label.textColor = UIColor(named: K.BrandColors.purple)
//        }
//        //This is a message from another sender.
//        else {
//            cell.leftImageView.isHidden = false
//            cell.rightImageView.isHidden = true
//            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
//            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
//        }
//
//
//
//        return cell
//    }
//}

import UIKit
import FirebaseAuth
import Firebase


class ChatViewController: UIViewController {
    
}
