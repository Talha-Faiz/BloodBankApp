//
//  LoginViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 28/01/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var secureTextEntryOutlet: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        secureTextEntryOutlet.tintColor = UIColor.gray
        
        // Do any additional setup after loading the view.
    }
    
//    func showAlert(alertTitle: String, alertMessage: String){
//        let alert = UIAlertController(title: alertTitle, message: alertMessage ,preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil )
//    }
    var counter = 0
    
    @IBAction func secureEntryBTn(_ sender: UIButton) {
        if counter == 0{
            secureTextEntryOutlet.tintColor = UIColor.black
            password.isSecureTextEntry = false
            counter = 1
        }else{
            secureTextEntryOutlet.tintColor = UIColor.gray
            password.isSecureTextEntry = true
            counter = 0
        }
        
    }
    @IBAction func SigninBtnPressed(_ sender: Any) {
        signinBtn.isEnabled = false
        if email.text!.isEmpty || password.text!.isEmpty {
          //  showAlert(alertTitle: "Required Fields", alertMessage: "Please enter all fields!!")
            showAlert(controller: self, title: "Required Fields", message: "Please enter all fields!!") { (ok) in
                self.signinBtn.isEnabled = true
            }
            
        }else{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
                    Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
                        if error == nil{
            //                self?.activityIndicator.isHidden = true
            //                self?.activityIndicator.stopAnimating()
                            print(authResult?.user.uid)
                            ServerCommunication.sharedDelegate.fetchUserData(userId: (authResult?.user.uid)!) { (status, message, user) in
                            
                                            if status{
                                                
                                                // Assign user while login
                                                
                                                // if user is already logged in there fore keeping user reference on sign in
                                                User.userSharefReference = user!
                                                print(authResult?.user.uid)
                                                self?.navigationController?.setNavigationBarHidden(true, animated: true)
                                                self?.performSegue(withIdentifier: "toDashboard", sender: nil)
                                                self?.activityIndicator.isHidden = false
                                                self?.activityIndicator.startAnimating()
                                            }else{
                                                self?.activityIndicator.isHidden = true
                                                self?.activityIndicator.stopAnimating()
                                                self?.showAlert(controller: self!, title: "Failure", message: message) { (ok) in
                                                    self!.signinBtn.isEnabled = true
                                                }
//                                                self?.showAlert(controller: self!, title: "Failure", message: message, actiontitle: "Ok", completion: { (okButtonPressed) in
//
//                                                    }
                                                //)
                                            }
                                        }
                        }else{
                            self?.activityIndicator.isHidden = true
                            self?.activityIndicator.stopAnimating()
                            //self!.showAlert(alertTitle: "Alert!", alertMessage: error!.localizedDescription)
                            self?.showAlert(controller: self!, title: "Alert!", message: error!.localizedDescription) { (ok) in
                                self!.signinBtn.isEnabled = true
                            }
                        }
                    }
        
    }
    
//    func showAlert(controller:UIViewController,title:String,message:String,actiontitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
//        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let delete = UIAlertAction(title: actiontitle, style: .destructive) { (alertAction) in
//            // ok button press
//            completion(true)
//        }
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
//            // ok button press
//            completion(false)
//        }
//        alerController.addAction(delete)
//        alerController.addAction(cancel)
//        controller.present(alerController, animated: true)
//    }
    
}
}
