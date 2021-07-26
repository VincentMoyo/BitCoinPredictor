//
//  ComparisonViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation

class ComparisonViewModel {
    
    private let apiClass = BitcoinAPI()
    private let database = DatabaseManager()
    private lazy var timerSeconds = 0
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    var predictedPriceData = PredictedPriceData()
    var didComparisonViewModelLoad: ((Bool) -> Void)?
    var comparisonViewModelError: ((Error) -> Void)?
    
    func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            getBitcoinPrincUsingAPI()
            loadPricesFromDatabse()
            loadPredictedPricesFromDatabse()
        } else {
            timerSeconds += 1
        }
    }
    
    private func getBitcoinPrincUsingAPI() {
        apiClass.getAPI { result in
            do {
                let newPrice = try result.get()
                self.database.insertPriceToDatabase(newPrice)
                self.priceData.price = Double(newPrice)!
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    private func loadPredictedPricesFromDatabse() {
        database.loadPredictedPriceFromDatabase { result in
            do {
                let newPredictedPrice = try result.get()
                self.predictedPriceData.currentPrice = Double(newPredictedPrice.price)!
                self.predictedPriceData.currentDate = Double(newPredictedPrice.date)!
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    private func loadPricesFromDatabse() {
        database.loadPricesFromDatabse { result in
            do {
                let newList = try result.get()
                self.priceList = newList
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
}
