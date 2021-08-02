//
//  LoginViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLoader.isHidden = true
        bindLoginViewModel()
        bindLoginViewModelErrors()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = self.emailTextField.text,
           let password = self.passwordTextField.text {
            loginViewModel.authenticateUser(email, password)
            activateActivityIndicatorView()
        }
    }
    
    private func bindLoginViewModel() {
        loginViewModel.didAuthenticateUserLoad = { result in
            if result {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.Authentication.kLoginSegue, sender: self)
                    self.activityLoader.stopAnimating()
                }
            }
        }
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.isHidden = false
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    private func bindLoginViewModelErrors() {
        loginViewModel.loginViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
            self.activityLoader.stopAnimating()
        }
    }
}
