//
//  AuthManager.swift
//  Flavorful
//
//  Created by Slarve N. on 3/20/21.
//

import Foundation
import Firebase

class AuthManager {
    
    var dict = [String: Any]()
    
    func createUser(email: String, password: String, image: UIImage, name: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            
            if let user = authResult?.user {
                
                //Save user to firestore user collection
                self.saveUser(email: user.email!, image: image, name: name)
                
                completionBlock(true)
            } else {
                completionBlock(false)
            }
            
        }
    }
    
    func saveUser(email: String, image: UIImage, name: String) {
        if let user = Auth.auth().currentUser {
            
            self.dict = [
                "uid": user.uid,
                "email": email as Any,
                "name": name,
                "profileImageUrl": ""
            ]
            
            //Save user info to firestore user collection
            Firestore.firestore().collection("users").document(user.uid).setData(self.dict) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            saveImage(image: image)
        }
    }
    
    func saveImage(image: UIImage) {
        
        if let user = Auth.auth().currentUser {
            
            //Get Firebase Storage reference to Save profile image
            let storageRef = Storage.storage().reference()
            let storageProfileRef = storageRef.child("profileImages").child(user.uid)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            //Convert image to jpeg Data
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            //Save image data to firebase Storage
            storageProfileRef.putData(imageData, metadata: metaData, completion: { (storageMetaData, error) in
                if error != nil {
                    return
                }
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if let metaImageUrl = url?.absoluteString{
                        self.dict["profileImageUrl"] = metaImageUrl
                        //Save user to firestore user collection
                        Firestore.firestore().collection("users").document(user.uid).updateData(self.dict) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                })
                
            })
        }
        
    }
    
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func reset(email: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }

    }
    
    func signOut() {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    

}
