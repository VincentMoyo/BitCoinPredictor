//
//  SettingsViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/03.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SettingsViewModel {
    
    var didSignOutUserLoad: ((Bool) -> Void)?
    var didLoadUserSetting: ((Bool) -> Void)?
    var signOutViewModelError: ((Error) -> Void)?
    private var database = DatabaseManager(databaseReference: Firestore.firestore())
    var userInformation = UserInformation()
    var userSettingsList: [UserInformationModel] = []
    
    func loadUserSettings() {
        database.loadUserSettings(SignedInUser: Auth.auth().currentUser!.uid) { result in
            do {
                let newUserSettings = try result.get()
                self.userSettingsList = newUserSettings
                self.didLoadUserSetting?(true)
            } catch {
                self.signOutViewModelError?(error)
            }
        }
    }
    
    func updateFirstName(_ firstName: String) {
        database.updateUserSettingsFirstName(SignedInUser: Auth.auth().currentUser!.uid, username: firstName)
    }
    
    func updateLastName(_ lastName: String) {
        database.updateUserSettingsLastName(SignedInUser: Auth.auth().currentUser!.uid, userLastName: lastName)
    }
    
    func updateGender(_ gender: String) {
        database.updateUserSettingsGender(SignedInUser: Auth.auth().currentUser!.uid, userGender: gender)
    }
    
    func updateDateOfBirth(_ dateOfBirth: String) {
        database.updateUserSettingsDateOfBirth(SignedInUser: Auth.auth().currentUser!.uid, DOB: dateOfBirth)
    }
    
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
