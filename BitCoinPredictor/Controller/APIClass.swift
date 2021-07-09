//
//  APIController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/02.
//

import Foundation

class APIClass {
    
    var dataManager = APIManager()
    var currentPrice = PriceData()
    var priceString: String = ""
    
    func getAPI(completion: @escaping (Result<(String),Error>) -> Void) {
        dataManager.getCoinPrice(for: "ZAR") { result in
            do
            {
                let currencyInfo = try result.get()
                self.currentPrice.price = Double(currencyInfo)!
                self.priceString = currencyInfo
                completion(.success(currencyInfo))
            } catch {
                print("there is an error \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
