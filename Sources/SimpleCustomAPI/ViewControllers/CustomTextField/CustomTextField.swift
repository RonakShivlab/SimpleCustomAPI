//
//  File.swift
//  
//
//  Created by STL on 06/03/24.
//

import Foundation
import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {

    func validateEmail() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailRegEx = "^.{6,15}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }

    func validatePassword() -> Bool {
        let passwordRegEx = "^.{6,15}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self.text)
    }

    func setErrorMessage(message: String) {
        self.layer.borderColor = UIColor.red.cgColor
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
}
