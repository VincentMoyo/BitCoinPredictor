//
//  APIController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/02.
//

import Foundation

class BitcoinAPI {
    
    var dataManager = APIManager()
    var currentPrice = PriceData()
    var priceString: String = ""
    var delegate: showUserErrorDelegate?
    
    func getAPI(completion: @escaping (Result<(String),Error>) -> Void) {
        dataManager.getCoinPrice(for: "ZAR") { result in
            do
            {
                let currencyInfo = try result.get()
                self.currentPrice.price = Double(currencyInfo)!
                self.priceString = currencyInfo
                completion(.success(currencyInfo))
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.delegate?.showUserErrorMessageDidInitiate(message)
                completion(.failure(error))
            }
        }
    }
}
