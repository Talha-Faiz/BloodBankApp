//
//  AddRequestViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 02/02/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit

class AddRequestViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    

    
    @IBOutlet weak var BloodGroupPicker: UITextField!
    
    
    let pickerView = UIPickerView()
    var bloodTypes = ["A+","A-","B+","B-","AB+","AB-","O-","O+"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self as! UIPickerViewDelegate
        pickerView.dataSource = self as! UIPickerViewDataSource
        BloodGroupPicker.inputView = pickerView

        // Do any additional setup after loading the view.
    }
    
    var addRequestProtocol : AddRequestDelegate?
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BloodGroupPicker.text = bloodTypes[row]
        //bloodGroup.resignFirstResponder()

    }
    
    @IBAction func addRequestBtn(_ sender: Any) {
        
        ServerCommunication.sharedDelegate.addRequest(bloodGroup: BloodGroupPicker.text!, userId: User.userSharefReference.userId, firstName: User.userSharefReference.firstName, imageUrl: User.userSharefReference.imageUrl) { (status, message) in
                   if status{
                // data is added
                self.showAlert(controller: self, title: "Success", message: message) { (ok) in
                    self.addRequestProtocol?.addRequest()
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                // error
                self.showAlert(controller: self, title: "Failed", message: message) { (ok) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
       }
        print("Hello")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    
}
