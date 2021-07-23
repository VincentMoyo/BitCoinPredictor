//
//  DataManager.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/09.
//

import Foundation

class APIManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey1 = "4645E475-133C-458A-AA48-2EB70A347301"
    let apiKey2 = "6FE19785-42B1-4D8E-92B3-EC4FDBE3DB75"
    let apiKey3 = "4ADA8654-C36C-448C-A383-3A2B2E5FE169"
    let apiKey4 = "ED0E63CD-0577-4190-8C24-BC1F2A276C21"
    
    func getCoinPrice(for currency: String, completion: @escaping (Result<(String), Error>) -> Void) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey4)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData)
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        completion(.success(priceString))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            let message = "Error parsing data: \(error)"
            delegate?.showUserErrorMessageDidInitiate(message)
            return nil
        }
    }
}
