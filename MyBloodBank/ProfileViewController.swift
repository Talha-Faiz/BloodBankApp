//
//  ProfileViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 29/01/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bloodgroupLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var signOutLabel: UIButton!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var user: User?
    var isComingFromMatchingDonarList: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "MatchingDonars", style: .plain, target: self, action: #selector(self.backToMatchingDonars))
    //    self.navigationItem.leftBarButtonItem?.isEnabled = false
  //      self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        if self.isComingFromMatchingDonarList {
           // self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(self.back)), animated: true)
            self.setDonarProfile(u: self.user!)
        } else {
            setupUserProfile()
        }
       
        userImage.roundedImage()
        

        // Do any additional setup after loading the view.
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.popViewController(animated: true)
     }
    
    
    func setDonarProfile(u: User) {
        self.signOutLabel.isHidden = true
        self.nameLabel.text = user!.firstName
        self.bloodgroupLabel.text = user!.bloodGroup
        self.emailLabel.text = user!.email
        self.dobLabel.text = user!.dateOfBirth
        self.phoneNumberLabel.text = user!.phoneNumber
        if let url = URL(string: user!.imageUrl){
            self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "person.circle"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//    }
    
    

//    @objc func backToMatchingDonars(){
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func setupUserProfile (){
        if User.userSharefReference != nil {
           self.nameLabel.text = User.userSharefReference.firstName
            // self.profileLastName.text = User.userSharefReference.lastName
             //self.profilePhoneNumber.text = User.userSharefReference.phoneNumber
             self.emailLabel.text = User.userSharefReference.email
             self.bloodgroupLabel.text = User.userSharefReference.bloodGroup
             self.dobLabel.text = User.userSharefReference.dateOfBirth
             self.phoneNumberLabel.text = User.userSharefReference.phoneNumber
             
             if let url = URL(string: User.userSharefReference.imageUrl){
                 self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "person.circle"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                     
                 }
             }
        }
        
    }
    

    @IBAction func signoutBtnPressed(_ sender: Any) {
        showAlert(controller: self, title: "Sign Out", message: "Are you sure that you want to sign out?", actionTitle: "SignOut") { (ok) in
            self.logOut()
        }
//        let alert = UIAlertController(title: "Sign Out", message: "Are you sure that you want to sign out?", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Sign Out", style: .default) { (UIAlertAction) in
//            self.logOut()
//        }
//        
//        let action1 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(action)
//        alert.addAction(action1)
//        present(alert, animated: true, completion: nil )
        
        
    }
    
    
        func logOut(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          User.userSharefReference = nil
            self.navigationController?.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    

}
