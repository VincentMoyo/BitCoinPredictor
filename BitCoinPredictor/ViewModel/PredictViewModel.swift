//
//  PredictViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation

class PredictViewModel {
    
    private let database = DatabaseManager()
    var priceList: [PriceListModel] = []
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
    
    func loadPricesFromDatabse() {
        database.loadPricesFromDatabse { result in
            do {
                let newList = try result.get()
                self.priceList = newList
                print("Byeeeer")
                self.didPredictViewModelLoad?(true)
            } catch {
                self.predictViewModelError?(error)
            }
        }
    }
}
