//
//  RegisterViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/02.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct RegisterViewModel {
    
    var didRegisterUserLoad: ((Bool) -> Void)?
    var registerViewModelError: ((Error) -> Void)?
    private var database = DatabaseManager(databaseReference: Firestore.firestore())
    var userInformation = UserInformation()
    
    func registerUser(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let err = error {
                registerViewModelError?(err)
            } else {
                setUpProfile()
                didRegisterUserLoad?(true)
            }
        }
    }
    
    func setUpProfile() {
        database.createUserSettings(signInUser: (Auth.auth().currentUser?.uid)!,
                                    userFirstName: userInformation.firstName,
                                    userLastName: userInformation.lastName,
                                    userGender: userInformation.gender,
                                    userDateOfBirth: userInformation.dateOfBirth)
    }
}
