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

protocol DatabaseMangerProtocol: AnyObject {
    func loadPrices(completion: @escaping (Result<[PriceArrayModel], Error>) -> Void)
    func loadPredictedPrice(completion: @escaping (Result<(price: String, date: String), Error>) -> Void)
    func loadBalances(completion: @escaping (Result<[BalanceArrayModel], Error>) -> Void)
    func loadUserSettings(SignedInUser userSetting: String, completion: @escaping (Result<[UserInformationModel], Error>) -> Void)
}
