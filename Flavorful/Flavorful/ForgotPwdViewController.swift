//
//  ForgotPwdViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/17/21.
//

import UIKit

class ForgotPwdViewController: UIViewController {

    @IBOutlet var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPwdBtn(_ sender: Any) {
        guard let email = emailText.text, email != "" else {
            let alertController = UIAlertController(title: nil, message: "Please enter an email", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
            
            return
        }
        resetPassword(email: email)
    }
    
    
    func resetPassword(email: String) {
        //If email not empty
        let signUpManager = AuthManager()
        if email != "" {
            signUpManager.reset(email: email) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    //Dismiss Keyboard and go back to login page
                    self.view.endEditing(true)
                    message = "We have sent you a link to reset your password. Please check your inbox."
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: self.dismissView(action:)))
                    self.present(alertController, animated: true)
                
                    
                } else {
                    message = "Error"
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    func dismissView(action: UIAlertAction) {
        self.navigationController?.popViewController(animated: true)
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
