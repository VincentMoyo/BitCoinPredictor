//
//  UserInformationModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/23.
//

import Foundation

struct UserInformationModel {
    let firstName: String
    let lastName: String
    let gender: String
    let dateOfBirth: String

    init(userInformation: UserInformationArray) {
        self.firstName = userInformation.firstName
        self.lastName = userInformation.lastName
        self.gender = userInformation.gender
        self.dateOfBirth = userInformation.dateOfBirth
    }
}
