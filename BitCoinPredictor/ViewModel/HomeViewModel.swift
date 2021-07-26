//
//  HomeViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/19.
//

import Foundation

class HomeViewModel {
    
    let apiClass = BitcoinAPI()
    let database = DatabaseManager()
    lazy var timerSeconds = 0
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    
    func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            getBitcoinPrincUsingAPI()
            loadPricesFromDatabse()
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
            } catch {
                
            }
        }
    }
    
    func loadPricesFromDatabse() {
        database.loadPricesFromDatabse { result in
            do {
                let newList = try result.get()
                self.priceList = newList
            } catch {
                
            }
        }
    }
}
