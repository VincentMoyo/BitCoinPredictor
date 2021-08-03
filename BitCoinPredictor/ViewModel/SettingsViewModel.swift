//
//  SettingsViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/03.
//

import Foundation
import FirebaseAuth

struct SettingsViewModel {
    
    var didSignOutUserLoad: ((Bool) -> Void)?
    var signOutViewModelError: ((Error) -> Void)?
    
    func signOutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            didSignOutUserLoad?(true)
        } catch let signOutError as NSError {
            signOutViewModelError?(signOutError)
        }
    }
}
