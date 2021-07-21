//
//  LoginViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let err = error {
                    let message = "\(err.localizedDescription)"
                    self.showUserErrorMessageDidInitiate(message)
                } else {
                    self.performSegue(withIdentifier: Constants.Authentication.kLoginSegue, sender: self)
                }
            }
        }
    }
}

extension LoginViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
