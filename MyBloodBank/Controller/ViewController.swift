//
//  ViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 28/01/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension UIViewController{
    
    func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            
            // ok button pressed
            completion(true)
        }
        alertController.addAction(okAction)
        controller.present(alertController,animated: true)
        }
    
    func showAlert(controller:UIViewController,title:String,message:String,actionTitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: actionTitle, style: .destructive) { (alertAction) in
            // ok button pressed
            completion(true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            // ok button pressed
          // completion(false)
        }
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        controller.present(alertController,animated: true)
    }
    
    
    
}

