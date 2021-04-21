//
//  AuthManager.swift
//  Flavorful
//
//  Created by Slarve N. on 3/20/21.
//

import Foundation
import Firebase
import FirebaseDatabase

class AuthManager {
    
    var convertedImageData: Data!
    var profileName : String!
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            //Save user to Firebase Realtime DB
            if let user = authResult?.user {
                var dict: Dictionary<String, Any> = [
                    "uid": user.uid,
                    "email": user.email as Any,
                    "name": self.profileName!,
                    "profileImageUrl": ""
                ]
                //Get Firebase reference to Save profile image to Storage
                let storageRef = Storage.storage().reference()
                let storageProfileRef = storageRef.child("profileImages").child(user.uid)
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                
                //Save image data to firebase Stoarge
                storageProfileRef.putData(self.convertedImageData, metadata: metaData, completion: { (storageMetaData, error) in
                    if error != nil {
                        return
                    }
                    storageProfileRef.downloadURL(completion: { (url, error) in
                        if let metaImageUrl = url?.absoluteString{
                            dict["profileImageUrl"] = metaImageUrl
                            //Save user to firebase realtime database
                            Database.database().reference().child("users").child(user.uid).setValue(dict)
                        }
                    })
                                          
                })
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    
    func saveImageAndName(image: UIImage, name: String) {
        //Convert image to jpeg Data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        convertedImageData = imageData
        profileName = name
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

