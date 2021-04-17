//
//  ProfileViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 4/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var fullNameText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    var profileName: String? = nil
    var profileEmail: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        retrieveProfileInfo()
    }
    
    func retrieveProfileInfo() {
        
        if let user = Auth.auth().currentUser {
            Database.database().reference()
                .child("users").child(user.uid).observe(DataEventType.value, with: { (snapshot) in
                    guard let values = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    self.profileNameLabel.text = values["name"] as? String
                    self.fullNameText.text = values["name"] as? String
                    self.emailText.text = values["email"] as? String
                    let imageUrl = values["profileImageUrl"] as? String
                    
                    let storageRef = Storage.storage().reference(forURL: imageUrl!)
                    storageRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                        if let _error = error{
                            print(_error)
                        } else {
                            if let _data  = data {
                                self.profileImageView.image = UIImage(data: _data)
                            }
                        }
                    }
                })
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let user = Auth.auth().currentUser;
        if validateAllFields() == true {
            
            //Updates Name and Email
            if let name = profileName, let email = profileEmail  {
                
                //Name
                let dict: Dictionary<String, Any> = [
                    "name": name,
                    "email": email
                ]
                //Email
                user?.updateEmail(to: email, completion: { (error) in
                    if error != nil{
                        let message = "Something went wrong."
                        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alertController, animated: true)
                    }
                })
                Database.database().reference().child("users").child(user!.uid).updateChildValues(dict)
            }
            //Go back
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func editPasswordBtn(_ sender: Any) {
        
        //Create the alert controller.
        let alert = UIAlertController(title: "Enter new Password", message: nil, preferredStyle: .alert)
        
        //Add actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let saveAction = (UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            //            //Save action clicked go back to login screen
            //            self.performSegue(withIdentifier: "initialScreen", sender: self)
        }))
        
        alert.addAction(saveAction)
        
        //Add the new password text field.
        alert.addTextField { (textField) in
            textField.text = ""
            saveAction.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                //saveAction.isEnabled = textField.text!.count > 0
                let validator = DataValidation()
                saveAction.isEnabled = validator.isValidPassword(password: textField.text!) // Only allow save option if password can be validated
                //Update firebase with new validated password
                let user = Auth.auth().currentUser;
                user?.updatePassword(to: (textField.text!), completion: {(error) in
                    if error == nil {
                    }
                })
                
            }
            
        }
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
        
    @IBAction func deleteUser(_ sender: Any) {
        let user = Auth.auth().currentUser;
        
        //Delete User Authentication
        user?.delete(completion: {(error) in
            if error == nil {
                //Go back to login screen
                self.performSegue(withIdentifier: "initialScreen", sender: self)
            }
        })
        
        //Delete All other information saved under current user
        //Delete current user recipes
        Database.database().reference().child("recipes").child(user!.uid).removeValue()
        //Delete current user
        Database.database().reference().child("users").child(user!.uid).removeValue()

        //Delete curent user profile image
        let storageRef = Storage.storage().reference()
        storageRef.child("profileImages").child(user!.uid).delete(completion: { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
            }
        })
        //Delete current user recipe images
        storageRef.child("recipeImages").child(user!.uid).delete(completion: { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
            }
        })
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        let authManager = AuthManager()
        authManager.signOut()
        //Go back to login screen
        self.performSegue(withIdentifier: "initialScreen", sender: self)
    }
    
    func validateAllFields() -> Bool {
        
        let validator = DataValidation()
        var result = true

        //Name
        if let name = fullNameText.text {
            if !name.isEmpty{
                //Save
                profileName = name
            } else {
                validator.validationError(errorMessage: "Enter your name", field: fullNameText)
                result = false
            }
        }
        //Email
        if let email = emailText.text {
            if validator.isValidEmail(email: email){
                //Save
                profileEmail = email
            } else {
                validator.validationError(errorMessage: "Invalid email", field: emailText)
                result = false
            }
        }
        return result
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

