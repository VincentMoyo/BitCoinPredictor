//
//  PredictViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation

class PredictViewModel {
    
    private var database = DatabaseManager()
    private let bitcoinAPI = BitcoinAPI()
    var priceList: [PriceListModel] = []
    var bitcoinPrice = PriceData()
    var predictedBitcoinPrice = PredictedPriceData()
    lazy var intervalValue = 0.0
    var didPredictViewModelLoad: ((Bool) -> Void)?
    var predictViewModelError: ((Error) -> Void)?
    
    func incrementByInterval(_ byteCoinPrice: Double, _ incrementValue: Double, _ increment: Bool) -> Double {
        var finalPrice = 0.0
        if incrementValue > 0 && byteCoinPrice > 0 {
            if increment {
                finalPrice = byteCoinPrice + incrementValue
            } else {
                finalPrice = byteCoinPrice - incrementValue
            }
        }
        return finalPrice
    }
    
    func loadPriceData() {
        bitcoinPrinceUsingAPI()
        loadPricesFromDatabase()
    }
    
    func insertPredictedPriceIntoDatabase(_ delegateError: ShowUserErrorDelegate, _ delegateSuccess: ShowUserSuccessDelegate?) {
        database.updatePredictedPriceIntoDatabase(String(predictedBitcoinPrice.currentPrice),
                                                  String(priceList.count + 5))
        
        database.delegateError = delegateError
        database.delegateSuccess = delegateSuccess
    }
    
    private func bitcoinPrinceUsingAPI() {
        bitcoinAPI.getAPI { result in
            do {
                let newPrice = try result.get()
                self.bitcoinPrice.price = Double(newPrice)!
                self.didPredictViewModelLoad?(true)
            } catch {
                self.predictViewModelError?(error)
            }
        }
    }
    
    private func loadPricesFromDatabase() {
        database.loadPricesFromDatabase { result in
            do {
                let newList = try result.get()
                self.priceList = newList
                self.didPredictViewModelLoad?(true)
            } catch {
                self.predictViewModelError?(error)
            }
        }
    }
}
