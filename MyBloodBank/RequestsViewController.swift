//
//  MatchingDonarsViewController.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 02/02/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol AddRequestDelegate {
    func addRequest()
}

class RequestsViewController: UIViewController, AddRequestDelegate {
    

    
    var requests: Array = [BloodGroup]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AllRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "AllRequestTableViewCell")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAllRequests()
    }
    
    
    func addRequest(){
        self.fetchAllRequests()
    }
    
    func fetchAllRequests(){
        ServerCommunication.sharedDelegate.fetchAllRequest { (status, message, requests) in
            if status{
                // success
               self.requests.removeAll()
                self.requests = requests!
             //   self.tasks.sort()

                self.tableView.reloadData()
            }else{
                // failure
             self.showAlert(controller: self, title: "Failure", message: message) { (ok) in
                    
                }
            }
        }



}
}

extension RequestsViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      //  return 5
//        return user.count
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AllRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AllRequestTableViewCell", for: indexPath) as! AllRequestTableViewCell
        cell.setData(title: "Blood Group Needed")
        cell.bloodGroupLabel.text = requests[indexPath.row].bloodGroup
        cell.nameLabel.text = requests[indexPath.row].firstName
        cell.date.text = requests[indexPath.row].date
        if let url = URL(string: requests[indexPath.row].imageUrl){
                cell.img_image.sd_setImage(with: url, placeholderImage: UIImage(named: "person.circle"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
       }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.showAlert(controller: self, title: "Delete Request", message: "Do you really want to delete this request?", actionTitle: "Delete") { (isDelete) in
                if isDelete{
                    ServerCommunication.sharedDelegate.deleteRequest(id: self.requests[indexPath.row].id) { (status, message) in
                        if status{
                            self.showAlert(controller: self, title: "Success", message: message) { (ok) in
                                self.requests.remove(at: indexPath.row)
                                self.tableView.reloadData()
                            }
                        }else{
                            self.showAlert(controller: self, title: "Fail", message: message) { (ok) in
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
