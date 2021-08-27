//
//  UserInformation.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/20.
//

import Foundation

struct UserInformation {
    private var initialFirstName = "Not Set >"
    private var initialSecondName = "Not Set >"
    private var initialGender = ""
    private var initialDateOfBirth = ""
    private var initialSender = ""
    
    var firstName: String {
        get {
            return initialFirstName
        }
        set {
            initialFirstName = newValue
        }
    }
    
    var lastName: String {
        get {
            return initialSecondName
        }
        set {
            initialSecondName = newValue
        }
    }
    
    var gender: String {
        get {
            return initialGender
        }
        set {
            initialGender = newValue
        }
    }
    
    var dateOfBirth: String {
        get {
            return initialDateOfBirth
        }
        set {
            initialDateOfBirth = newValue
        }
    }
    
    var sender: String {
        get {
            return initialSender
        }
        set {
            initialSender = newValue
        }
    }
}
