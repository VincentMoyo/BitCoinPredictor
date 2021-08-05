//
//  UserAlerts.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/13.
//

import UIKit

protocol ErrorReporting: AnyObject {
    func showUserErrorMessageDidInitiate(_ message: String)
}

protocol DisplayingSuccessMessage: AnyObject {
    func showUserSuccessMessageDidInitiate(_ message: String)
}
