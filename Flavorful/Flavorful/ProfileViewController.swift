//
//  ProfileViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 4/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
            let db = Database.database().reference().child("users").child(user.uid)
            
            db.observe(DataEventType.value, with: { (snapshot) in
                let userInfo = snapshot.value as? [String : AnyObject] ?? [:]
                self.profileNameLabel.text = userInfo["name"] as? String
                self.fullNameText.text = userInfo["name"] as? String
                self.emailText.text = userInfo["email"] as? String
                
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
        
        
    @IBAction func deleteUser(_ sender: Any) {
        let user = Auth.auth().currentUser;
        user?.delete(completion: {(error) in
            if error == nil{
                //Go back to login screen
                self.performSegue(withIdentifier: "initialScreen", sender: self)
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
        //Password
//        if let password = passwordText.text {
//            if validator.isValidPassword(password: password){
//                //Save
//                profilePassword = password
//            } else {
//                validator.validationError(errorMessage: "Invalid Passsowrd", field: passwordText)
//                result = false
//            }
//        }
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
