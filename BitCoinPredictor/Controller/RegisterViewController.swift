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
    
    var delegateError: showUserErrorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    let message = "\(e.localizedDescription)"
                    self.showUserErrorMessageDidInitiate(message)
                } else {
                    self.performSegue(withIdentifier: K.Authentication.registerSegue, sender: self)
                }
                
            }
        }
    }
}

extension RegisterViewController: showUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
