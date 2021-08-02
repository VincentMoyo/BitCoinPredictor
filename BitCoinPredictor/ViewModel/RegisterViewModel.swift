//
//  RegisterViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/02.
//

import Foundation
import FirebaseAuth

struct RegisterViewModel {
    
    var didRegisterUserLoad: ((Bool) -> Void)?
    var registerViewModelError: ((Error) -> Void)?
    
    func registerUser(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let err = error {
                registerViewModelError?(err)
            } else {
                didRegisterUserLoad?(true)
            }
        }
    }
}
