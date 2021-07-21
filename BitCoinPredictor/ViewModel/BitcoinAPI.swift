//
//  APIController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/02.
//

import Foundation

class BitcoinAPI {
    
    lazy var dataManager = APIManager()
    lazy var currentPrice = PredictedPriceData()
    var delegate: ShowUserErrorDelegate?
    
    func getAPI(completion: @escaping (Result<(String),Error>) -> Void) {
        dataManager.getCoinPrice(for: "ZAR") { result in
            do
            {
                let currencyInfo = try result.get()
                completion(.success(currencyInfo))
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.delegate?.showUserErrorMessageDidInitiate(message)
                completion(.failure(error))
            }
        }
    }
}
