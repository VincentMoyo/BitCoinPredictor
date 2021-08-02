//
//  LoginViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/02.
//

import Foundation
import FirebaseAuth

struct LoginViewModel {
    
    var didAuthenticateUserLoad: ((Bool) -> Void)?
    var loginViewModelError: ((Error) -> Void)?
    
    func authenticateUser(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let err = error {
                loginViewModelError?(err)
            } else {
                didAuthenticateUserLoad?(true)
            }
        }
    }
}
