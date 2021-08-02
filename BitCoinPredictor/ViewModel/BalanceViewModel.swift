//
//  BalanceViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/08/01.
//

import Foundation

class BalanceViewModel {
    
    private let database = DatabaseManager()
    var predictedPrice = PredictedPriceData()
    var balanceData = BalanceData()
    private lazy var timerSeconds = 0
    var balanceList: [BalanceListModel] = []
    var previousPrediction = 0.0
    var didBalanceViewModelLoad: ((Bool) -> Void)?
    var balanceViewModelError: ((Error) -> Void)?
    
    func updateTimer() {
        if timerSeconds % 7 == 0 {
            timerSeconds += 1
            loadPredictedPricesFromDatabase()
            loadBalancesFromDatabase()
        } else {
            timerSeconds += 1
        }
    }
    
    private func loadBalancesFromDatabase() {
        if previousPrediction == predictedPrice.currentPrice {
            database.loadBalanceFromDatabase { result in
                do {
                    let newList = try result.get()
                    self.balanceList = newList
                    newList.forEach { accountBalance in
                        self.balanceData.balance = Double(accountBalance.balance)!.rounded()
                        self.balanceData.equity = Double(accountBalance.equity)!.rounded()
                        self.balanceData.freeMargin = Double(accountBalance.freeMargin)!.rounded()
                        self.balanceData.bitcoin = Double(accountBalance.bitcoin)!.rounded()
                    }
                    self.didBalanceViewModelLoad?(true)
                } catch {
                    self.balanceViewModelError?(error)
                }
            }
        } else {
            balanceData.balance -= predictedPrice.currentPrice
            updateBalanceDatabase()
        }
        previousPrediction = predictedPrice.currentPrice
    }
    
    private func updateBalanceDatabase() {
        database.updateAccountBalceDatabase(String(balanceData.balance),
                                            String(balanceData.equity),
                                            String(balanceData.freeMargin),
                                            String(balanceData.bitcoin))
    }
    
    private func loadPredictedPricesFromDatabase() {
        database.loadPredictedPriceFromDatabase { result in
            do {
                let newPredictedPrice = try result.get()
                self.predictedPrice.currentPrice = Double(newPredictedPrice.price)!
                self.didBalanceViewModelLoad?(true)
            } catch {
                self.balanceViewModelError?(error)
            }
        }
    }
}
