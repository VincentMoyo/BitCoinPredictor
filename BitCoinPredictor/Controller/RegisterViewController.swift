//
//  RegisterViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegateError: ShowUserErrorDelegate?
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let err = error {
                    let message = "\(err.localizedDescription)"
                    self.showUserErrorMessageDidInitiate(message)
                } else {
                    self.performSegue(withIdentifier: Constants.Authentication.kRegisterSegue, sender: self)
                }
                
            }
        }
    }
}

extension RegisterViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
