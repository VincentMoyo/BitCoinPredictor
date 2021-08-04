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
    var previousPrice = 570000.0
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    var didHomeViewModelLoad: ((Bool) -> Void)?
    var homeViewModelError: ((Error) -> Void)?
    var counter = 0
    
    func updateTimer() {
        if timerSeconds % 5 == 0 && counter < 10 {
            timerSeconds += 1
            counter += 1
            bitcoinPriceUsingAPI()
            loadPricesFromDatabase()
        } else {
            timerSeconds += 1
        }
    }
    
    func bitcoinPriceUsingAPI() {
        apiClass.getAPI { result in
            do {
                let newPrice = try result.get()
                self.database.insertPrice(newPrice)
                self.priceData.price = Double(newPrice)!
                self.didHomeViewModelLoad?(true)
            } catch {
                self.homeViewModelError?(error)
            }
        }
    }
    
    func loadPricesFromDatabase() {
        database.loadPrices { result in
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
