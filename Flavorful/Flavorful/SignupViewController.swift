//
//  SignupViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/17/21.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    public var profileImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        //Create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        //Add it to the image view;
        profileImageView.addGestureRecognizer(tapGesture)
        //Make sure imageView can be interacted with by user
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        //Open Image Picker
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //Save and show imaged picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let signUpManager = AuthManager()
        let validator = DataValidation()
        if let email = emailText.text, let password = passwordText.text {
            
            
            if validator.isValidEmail(email: email) == true {
                if validator.isValidPassword(password: password) == true{
                    //If both email and password valid then create a user
                    signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                        guard let `self` = self else { return }
                        var message: String = ""
                        if (success) {
                            self.performSegue(withIdentifier: "signUp", sender: self)
                        } else {
                            message = "something went wrong."
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alertController, animated: true)
                        }
                    }
                    //Else display error
                } else{
                    passwordText.text = ""
                    let placeholderColor = UIColor.red
                    passwordText.attributedPlaceholder = NSAttributedString(string: passwordText.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
                    passwordText.placeholder = "Invalid Password"
                }
                //Else display error
            } else{
                emailText.text = ""
                let placeholderColor = UIColor.red
                emailText.attributedPlaceholder = NSAttributedString(string: passwordText.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
                emailText.placeholder = "Invalid Email"
            }
            
        }
        
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
