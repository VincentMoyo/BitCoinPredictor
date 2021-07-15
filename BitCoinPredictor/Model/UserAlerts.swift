//
//  UserAlerts.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/13.
//

import UIKit

protocol showUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String)
}
 
protocol showUserSucessDelegate {
    func showUserSucessMessageDidInitiate(_ message: String)
}
