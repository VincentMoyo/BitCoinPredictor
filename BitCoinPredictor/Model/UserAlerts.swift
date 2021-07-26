//
//  UserAlerts.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/13.
//

import UIKit

protocol ShowUserErrorDelegate: AnyObject {
    func showUserErrorMessageDidInitiate(_ message: String)
}

protocol ShowUserSucessDelegate: AnyObject {
    func showUserSucessMessageDidInitiate(_ message: String)
}
