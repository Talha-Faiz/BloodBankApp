//
//  SignupViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 28/01/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var bloodGroup: UITextField!
    @IBOutlet weak var DateOfBirth: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confrimPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var datePicker: UIDatePicker?
    @IBOutlet weak var secureTextEntryOutlet: UIButton!
    
    let pickerView = UIPickerView()
    var bloodTypes = ["A+","A-","B+","B-","AB+","AB-","O-","O+"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secureTextEntryOutlet.tintColor = UIColor.gray
        imageView.roundedImage()
        self.activityIndicator.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        bloodGroup.inputView = pickerView
        //creatDatePicker()
        
        
                
                datePicker = UIDatePicker()
                datePicker?.datePickerMode = .date
                DateOfBirth.inputView = datePicker
                //datePicker?.tintColor = .clear
                datePicker?.addTarget(self, action: #selector(SignupViewController.dateChanged(datePicker:)), for: .valueChanged)
                
                let tapGasture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.viewTapped(gestureRecognizer:)))
                view.addGestureRecognizer(tapGasture)
        
        addGesture()
    }
    var counter = 0
    @IBAction func secureTextEntryBtn(_ sender: Any) {
        
        if counter == 0{
            secureTextEntryOutlet.tintColor = UIColor.black
            password.isSecureTextEntry = false
            confrimPassword.isSecureTextEntry = false
            counter = 1
        }else{
            secureTextEntryOutlet.tintColor = UIColor.gray
            password.isSecureTextEntry = true
            confrimPassword.isSecureTextEntry = true
            counter = 0
        }
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DateOfBirth.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    
//    func showAlert(alertTitle: String, alertMessage: String){
//        let alert = UIAlertController(title: alertTitle, message: alertMessage ,preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil )
//    }
    
    @IBAction func SignupBtnPressed(_ sender: Any) {
        signupBtn.isEnabled = false
        if firstName.text!.isEmpty == true || lastName.text!.isEmpty == true || phoneNumber.text!.isEmpty == true || email.text!.isEmpty == true || bloodGroup.text!.isEmpty == true || DateOfBirth.text!.isEmpty  == true || password.text!.isEmpty == true || confrimPassword.text!.isEmpty == true {
//            showAlert(alertTitle: "Required Fields", alertMessage: "Please enter all fields!!")
            showAlert(controller: self, title: "Required Fields", message: "Please enter all fields!!") { (ok) in
                self.signupBtn.isEnabled = true
            }
            
        }else{
            
            if password.text!.count < 6 {
                showAlert(controller: self, title: "Alert", message: "Password should be greater than 5 character") { (ok) in
                    self.signupBtn.isEnabled = true
                }
            }else{
                if password.text != confrimPassword.text{
                  //  showAlert(alertTitle: "Alert", alertMessage: "Password and Confirm Password does not match")
                    showAlert(controller: self, title: "Alert", message: "Password and Confirm Password does not match") { (ok) in
                    self.signupBtn.isEnabled = true
                    }
                }else{
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                        if error == nil{
//                            self.activityIndicator.isHidden = true
//                            self.activityIndicator.stopAnimating()
                            print(authResult?.user.uid)
                            ServerCommunication.sharedDelegate.uploadImage(image: self.imageView.image!, userId: (authResult?.user.uid)!) { (status, response) in
                                if status{
                                    // Image uploaded
                                    
                                    let newUser = User(firstName: self.firstName.text!, lastName: self.lastName.text!, dateOfBirth: self.DateOfBirth.text!, bloodGroup: self.bloodGroup.text!, phoneNumber: self.phoneNumber.text!, email: self.email.text!, userId: ((authResult?.user.uid)!), imageUrl: response)
                                    
                                    // Assign current user while creating account
                                    User.userSharefReference = newUser
                                    
                                        ServerCommunication.sharedDelegate.uploadUserData(userData: newUser.getUserDict()) { (status, message) in
                                        
                                        if status{
                                            

                                            // Move to Home screen
                                            self.navigationController?.setNavigationBarHidden(true, animated: false)
                                            self.performSegue(withIdentifier: "toDashboard", sender: nil)
                                            self.activityIndicator.isHidden = true
                                            self.activityIndicator.stopAnimating()
                                        }else{
                                            self.activityIndicator.isHidden = true
                                            self.activityIndicator.stopAnimating()
                                            self.showAlert(controller: self, title: "Error", message: message) { (ok) in
                                                // ok button pressed
                                                self.signupBtn.isEnabled = true
                                            }
                                        }
                                    }
                                }else{
                                    
                                    self.activityIndicator.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                    self.showAlert(controller: self, title: "Error", message: response) { (ok) in
                                        // Ok button pressed
                                        self.signupBtn.isEnabled = true
                                    }
                                }
                            }
                        }else{
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                          //  self.showAlert(alertTitle: "Alert!", alertMessage: error!.localizedDescription)
                            self.showAlert(controller: self, title: "Alert!", message: error!.localizedDescription) { (ok) in
                                self.signupBtn.isEnabled = true
                            }
                        }
                    }
                    
                }
            }
            
        
    }
    }
    
    
    func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    
    @objc func userImageTapped(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (ok) in
            // Camera option tapped
            self.presentImagePicker(type: .camera)
            self.modalPresentationStyle = .fullScreen
        }
        
        let photoGallery = UIAlertAction(title: "Gallery", style: .default) { (gallery) in
            // Gallery option tapped
            self.presentImagePicker(type: .photoLibrary)
            self.modalPresentationStyle = .fullScreen
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            // Cancel Tapped
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoGallery)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentImagePicker(type:UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension SignupViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil)
        }
    
//    func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
//        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
//            // ok button press
//            completion(true)
//        }
//        alerController.addAction(okAction)
//        controller.present(alerController, animated: true)
//    }
//
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

extension SignupViewController:UIPickerViewDelegate,UIPickerViewDataSource  {

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodGroup.text = bloodTypes[row]
        //bloodGroup.resignFirstResponder()

    }

}

