//
//  WelcomeViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/03.
//

import Foundation
import FirebaseAuth

struct WelcomeViewModel {
    
    func sigInInUser() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
}
