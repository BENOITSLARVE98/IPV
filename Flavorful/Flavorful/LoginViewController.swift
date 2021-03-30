//
//  LoginViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/17/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    var profileEmail: String? = nil
    var profilePassword: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Hide back button bar
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //Set TextFields Max Length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength : Int = 0
        if textField == emailText{
            maxLength = 64
        } else if textField == passwordText{
            maxLength = 15
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        let authManager = AuthManager()
        
        if validateAllFields() == true {
            guard let email = profileEmail, let password = profilePassword else { return }
            authManager.signIn(email: email, pass: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    message = "Invalid email or password."
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

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
