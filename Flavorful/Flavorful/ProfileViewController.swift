//
//  ProfileViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 4/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var fullNameText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    var profileImage: UIImage? = nil
    var profileName: String? = nil
    var profileEmail: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayUserInfo()
        
        //Create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        //Add it to the image view;
        profileImageView.addGestureRecognizer(tapGesture)
        //Make sure imageView can be interacted with by user
        profileImageView.isUserInteractionEnabled = true
    }
    
    func displayUserInfo() {
        
        //Retrieve user profile data from Firestore
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                //Display user data
                self.profileNameLabel.text = data["name"] as? String
                self.fullNameText.text = data["name"] as? String
                self.emailText.text = data["email"] as? String
                let imageUrl = data["profileImageUrl"] as? String
                
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
            }
        }
        
    }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let authManager = AuthManager()
        let user = Auth.auth().currentUser;
        if validateAllFields() == true {
            
            //Updates Name and Email
            if let name = profileName, let email = profileEmail, let image = profileImage  {

                //Name
                let dict: Dictionary<String, Any> = [
                    "name": name,
                    "email": email,
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
                Firestore.firestore().collection("users").document(user!.uid).updateData(dict)
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
        
        //Delete current user
        Firestore.firestore().collection("users").document(user!.uid).delete()
        //Delete current user recipes
        //Database.database().reference().child("recipes").child(user!.uid).removeValue()

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
    
    
    // IMAGE PICKING
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        //Open Image Picker
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //Save and show imaged picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            //Set imageView to display selected image
            profileImageView.image = imageSelected
            //Save selected image
            profileImage = imageSelected
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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

