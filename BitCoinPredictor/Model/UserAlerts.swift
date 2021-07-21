//
//  UserAlerts.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/13.
//

import UIKit

protocol ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String)
}

protocol ShowUserSucessDelegate {
    func showUserSucessMessageDidInitiate(_ message: String)
}
