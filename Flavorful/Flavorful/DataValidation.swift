//
//  DataValidation.swift
//  Flavorful
//
//  Created by Slarve N. on 3/20/21.
//

import Foundation
import UIKit

class DataValidation {
    
    //Validate Email
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    //Validate Password
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: password)
        return result
    }
    
    //Show error message for textFields
    func validationError(errorMessage: String, field: UITextField){
        field.text = ""
        let placeholderColor = UIColor.red
        field.attributedPlaceholder = NSAttributedString(string: field.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        field.placeholder = errorMessage
    }
    
}
