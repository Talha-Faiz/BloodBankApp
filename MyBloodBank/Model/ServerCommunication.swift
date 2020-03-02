//
//  ServerCommunication.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 30/01/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

public class ServerCommunication{
    var firebaseFirestore:Firestore!
       var firebaseStorage:Storage!
        var ref: DatabaseReference!
        static var sharedDelegate = ServerCommunication()
        
       
       private init() {
           firebaseFirestore = Firestore.firestore()
           firebaseStorage = Storage.storage()
       }

       func uploadUserData(userData:[String:Any],completion:@escaping(_ status:Bool,_ message:String)->Void){
           let userId = userData["UserId"] as! String
           firebaseFirestore.collection("Users").document(userId).setData(userData) { (error) in
               if error == nil{
                   completion(true,"User data uploaded")
               }else{
                   completion(false,error!.localizedDescription)
               }
           }
       }
    func deleteRequest(id:String,completion:@escaping(_ status:Bool, _ message:String)->Void){
        
        
        firebaseFirestore.collection("RequestedBloodGroup").document(id).delete { (error) in
            if error == nil{
                completion(true,"Request is deleted")
            }else{
                completion(false,error!.localizedDescription)
            }
        }
        
    } 
    
    
       
       func uploadImage(image:UIImage,userId:String,completion:@escaping(_ status:Bool,_ response:String)->Void){
           // if status is true then downloadurl will be in response
           
           
           // Data in memory
           guard let data = image.jpegData(compressionQuality: 0.2) else{
               completion(false,"Unable to get data from image")
               return
           }

           // Create a reference to the file you want to upload
           let riversRef = firebaseStorage.reference().child("images/\(userId).jpg")
            
           // Upload the file to the path "images/rivers.jpg"
           let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
             guard let _ = metadata else {
               // Uh-oh, an error occurred!
               completion(false,error!.localizedDescription)
               return
             }
             // You can also access to download URL after upload.
             riversRef.downloadURL { (url, error) in
               guard let downloadURL = url else {
                 // Uh-oh, an error occurred!
                   completion(false,error!.localizedDescription)
                 return
               }
               
               completion(true,downloadURL.absoluteString)
               
               }
           }
       }
       
       func fetchUserData(userId:String,completion:@escaping(_ status:Bool,_ message:String,_ user:User?)->Void){
           
           // downloading user data using initialized firebase keys as dictionary
           
           firebaseFirestore.collection("Users").document(userId).getDocument { (snapshot, error) in
               if let snapshot = snapshot{
                   // you get some data
                   if let userDic = snapshot.data(){
                       let user = User(userDict: userDic)
                       completion(true,"Get user Data",user)
                   }else{
                       completion(false,"Unable to get user data",nil)
                   }

               }else{
                   // you get an error
                   completion(false,error!.localizedDescription,nil)
               }
           }
       }
    
    func fetchUsersForMessage(user: [User]){
        for i in user{
            print(i.firstName)
        }
    }
       
       func fetchAllDonarsData (completion:@escaping(_ status:Bool, _ message:String, _ users:[User]?) -> Void) {
           firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
               if error == nil {
                   // Success
                   if let usersData = snapshot?.documents {
                   // Got Donars
                   var users:Array = [User]()
                    var usersForMessage:Array = [User]()
                    for matchingUser in usersData {
                           let usersDocuments = matchingUser.data()
                      //  print(Auth.auth().currentUser?.uid)
                            let userId = usersDocuments["UserId"] as! String
                        if userId == Auth.auth().currentUser?.uid{
                        }else {
                            let firstName = usersDocuments["FirstName"] as! String
                            let bloodGroup = usersDocuments["BloodGroup"] as! String
                            let imageUrl = usersDocuments["ImageURL"] as! String
                            let lastName = usersDocuments["LastName"] as! String
                            let email = usersDocuments["Email"] as! String
                            let dateOfBirth = usersDocuments["DateOfBirth"] as! String
                            let phoneNumber = usersDocuments["PhoneNumber"] as! String
                            let user = User(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, bloodGroup: bloodGroup, phoneNumber: phoneNumber, email: email, userId: userId, imageUrl: imageUrl)
                            
                            
                            if User.userSharefReference.bloodGroup == "A+"{
                                switch bloodGroup {
                                case "A+", "A-", "O+", "O-":
                                    users.append(user)
                                    
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "A-"{
                                switch bloodGroup {
                                case "A-", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "B+"{
                                switch bloodGroup {
                                case "B+", "B-", "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "B-"{
                                switch bloodGroup {
                                case "B-", "O+":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "AB+"{
                                switch bloodGroup {
                                case "A+", "A-", "O+", "O-", "B+","B-","AB+","AB-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "AB-"{
                                switch bloodGroup {
                                case "A-","O-","B-","AB-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "O+"{
                                switch bloodGroup {
                                case "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "O-"{
                                switch bloodGroup {
                                case "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }
                           usersForMessage.append(user)
                           
                            
                        }
                        
                        
                           
                       }
                    self.fetchUsersForMessage(user: usersForMessage)
                       completion(true, "Get Donars", users)
                   } else {
                       // Donars doc not found
                       completion(false, "Donars Data Not Found", nil)
                   }
               } else {
                   // faliure
                   completion(false, error!.localizedDescription,nil)
               }
           }
       }
    
    func addRequest(bloodGroup: String,userId:String,firstName:String,imageUrl:String,completion:@escaping(_ status:Bool,_ message:String)->Void){
        
        
        let newRequest = firebaseFirestore.collection("RequestedBloodGroup").document()
            
        newRequest.setData(["BloodGroup":bloodGroup,"FullName":firstName,"imageUrl":imageUrl,"Date":FieldValue.serverTimestamp(),"Id":newRequest.documentID,"UserId":User.userSharefReference.userId]) { (error) in
            if error == nil{
                // Success
                completion(true,"Request is added")
            }else{
                // Fail
                completion(false,(error?.localizedDescription)!)
            }
        }
    }
    
    func fetchAllRequest(completion:@escaping(_ status:Bool, _ message:String,_ requests:[BloodGroup]?)->Void){
        
      //  print(User.userSharefReference.userId)
        firebaseFirestore.collection("RequestedBloodGroup").getDocuments { (snapshot, error) in
            
            if error == nil{
                // success
                if let tasksDoc = snapshot?.documents{
                    // got tasks
                    var requests:Array = [BloodGroup]()
                    for taskDoc in tasksDoc{
                        let taskData = taskDoc.data()
                        
                        let bloodGroup = taskData["BloodGroup"] as! String
                        let date = taskData["Date"] as! Timestamp
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                        let actualDate = formatter.string(from: date.dateValue())
                        let id = taskData["Id"] as! String
                        let name = taskData["FullName"] as! String
                        let imageUrl = taskData["imageUrl"] as! String
                        
//                        let request = BloodGroup(bloodGroup: bloodGroup, userId: User.userSharefReference.userId, date: date.dateValue(), id: id)
                        let request = BloodGroup(bloodGroup: bloodGroup, userId: User.userSharefReference.userId, date: actualDate, id: id, firstName: name, imageUrl:imageUrl)
                        requests.append(request)
                        
                        
                        
                    }
                    completion(true,"Get tasks",requests)
                    
                    
                }else{
                    // task doc not found
                    completion(false,"Task data not found",nil)
                }
            }else{
                // failure
                completion(false,error!.localizedDescription,nil)
            }
        }
    }

    
   
 }



