//
//  HomeViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/19.
//

import Foundation

class HomeViewModel {
    
    private let apiClass = BitcoinAPI()
    private let database = DatabaseManager()
    private lazy var timerSeconds = 0
    var previousPrice = 600000.0
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    var didHomeViewModelLoad: ((Bool) -> Void)?
    var homeViewModelError: ((Error) -> Void)?
    
    func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            getBitcoinPriceUsingAPI()
            loadPricesFromDatabase()
        } else {
            timerSeconds += 1
        }
    }
    
    private func getBitcoinPriceUsingAPI() {
        apiClass.getAPI { result in
            do {
                let newPrice = try result.get()
                self.database.insertPriceToDatabase(newPrice)
                self.priceData.price = Double(newPrice)!
                self.didHomeViewModelLoad?(true)
            } catch {
                self.homeViewModelError?(error)
            }
        }
    }
    
    private func loadPricesFromDatabase() {
        database.loadPricesFromDatabase { result in
            do {
                let newList = try result.get()
                self.priceList = newList
                self.didHomeViewModelLoad?(true)
            } catch {
                self.homeViewModelError?(error)
            }
        }
    }
}
