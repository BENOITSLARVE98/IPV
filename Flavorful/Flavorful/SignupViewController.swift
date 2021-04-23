//
//  SignupViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/17/21.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var fullNameText: UITextField!
    @IBOutlet var profileImageLabel: UILabel!
    
    var profileImage: UIImage? = nil
    var profileName: String? = nil
    var profileEmail: String? = nil
    var profilePassword: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Hide back button bar
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        //Add it to the image view;
        profileImageView.addGestureRecognizer(tapGesture)
        //Make sure imageView can be interacted with by user
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    
    
    //Set TextFields Max Length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength : Int = 0
        if textField == fullNameText{
            maxLength = 64
        }
        if textField == emailText{
            maxLength = 64
        } else if textField == passwordText{
            maxLength = 15
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let authManager = AuthManager()
        if validateAllFields() == true {
            
//            //Send image and name to be saved to Firebase Storage
//            if let image = profileImage, let name = profileName {
//                authManager.saveImageAndName(image: image, name: name)
//            }
            //Create user and Authenticate
            guard let email = profileEmail, let password = profilePassword, let image = profileImage, let name = profileName else { return }
            authManager.createUser(email: email, password: password, image: image, name: name) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    self.performSegue(withIdentifier: "signUp", sender: self)
                } else {
                    message = "Something went wrong."
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    

    func validateAllFields() -> Bool {
        
        let validator = DataValidation()
        var result = true

        //Image
        guard profileImage != nil else {
            //Error
            profileImageLabel.text = "Please pick an image"
            profileImageLabel.textColor = UIColor.red
            result = false
            return result
        }
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
        if let password = passwordText.text {
            if validator.isValidPassword(password: password){
                //Save
                profilePassword = password
            } else {
                validator.validationError(errorMessage: "Invalid Passsowrd", field: passwordText)
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
