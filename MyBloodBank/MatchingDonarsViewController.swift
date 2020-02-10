//
//  NewsFeedViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 02/02/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth

class MatchingDonarsViewController: UIViewController {
    
     var user = [User]()
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
      self.tableView.register(UINib(nibName: "AllRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "AllRequestTableViewCell")
    }
    
    
    
    func fetchAllDOnarsData() {
            ServerCommunication.sharedDelegate.fetchAllDonarsData { (status, message, users) in
                if status {
                    self.user = users!
                    self.tableView.reloadData()
                } else {
                    // faliure
                    print ("Could not find Data")
                }
            }
        }
    
    func fetchUserData(){
           if User.userSharefReference == nil{
            if let user = Auth.auth().currentUser{
                   ServerCommunication.sharedDelegate.fetchUserData(userId: user.uid) { (status, message, user) in
                       if status{
                           User.userSharefReference = user!
                           self.fetchAllDOnarsData()
                       }else{
                        
                        self.showAlert(controller: self, title: "Failure", message: message, actionTitle: "Ok") { (okButtonPressed) in
                        }
                              //  handle this
                           }
                       }
               }else{
                self.fetchAllDOnarsData()
            }
           }else{
            self.fetchAllDOnarsData()
        }
           }
       }
    


extension MatchingDonarsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AllRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AllRequestTableViewCell", for: indexPath) as! AllRequestTableViewCell
        cell.bloodGroupLabel.text = user[indexPath.row].bloodGroup
        cell.nameLabel.text = user[indexPath.row].firstName
        //cell.imageView?.image = user[indexPath.row].imageUrl
        if let url = URL(string: user[indexPath.row].imageUrl){
            cell.img_image.sd_setImage(with: url, placeholderImage: UIImage(named: "person.circle"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = self.user[indexPath.row].userId
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
     //   let nav = UINavigationController(rootViewController: vc)
     //   vc.modalPresentationStyle = .fullScreen
        ServerCommunication.sharedDelegate.fetchUserData(userId: userID) { (status, message, user) in
            if status{
               
        
             //   vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "MatchingDonars", style: .plain, target: self, action: #selector(self.backToMatchingDonars))
                vc.user = user
                vc.isComingFromMatchingDonarList = true
                
                
              //  self.present(nav, animated: true, completion: nil)
               self.navigationController!.pushViewController(vc, animated: true)
                
                
             //   print(vc.)
//                print(user!.firstName)
//                print(user!.bloodGroup)
//                print(user!.email)
//                print(user!.dateOfBirth)
                //vc.setupUserProfile()
                
//                self.tabBarController?.selectedIndex = 2
            }else{
                
            }
        }
        
    }
    
//    @objc func backToMatchingDonars(){
//
//    }
   
    
}



 
