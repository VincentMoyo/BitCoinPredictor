//
//  RegisterViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    
    private var registerViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLoader.isHidden = true
        bindRegisterViewModel()
        bindRegisterViewModelErrors()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            registerViewModel.registerUser(email, password)
            activateActivityIndicatorView()
        }
    }
    
    private func bindRegisterViewModel() {
        registerViewModel.didRegisterUserLoad = { result in
            if result {
                self.performSegue(withIdentifier: Constants.Authentication.kRegisterSegue, sender: self)
                self.activityLoader.stopAnimating()
            }
        }
    }
    
    private func activateActivityIndicatorView() {
        activityLoader.isHidden = false
        activityLoader.hidesWhenStopped = true
        activityLoader.startAnimating()
    }
    
    private func bindRegisterViewModelErrors() {
        registerViewModel.registerViewModelError = { result in
            self.showUserErrorMessageDidInitiate(result.localizedDescription)
            self.activityLoader.stopAnimating()
        }
    }
}
