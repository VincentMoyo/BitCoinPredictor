//
//  DataManager.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/09.
//

import Foundation

struct APIManager {
    
    func getCoinPrice(for currency: String, completion: @escaping (Result<(String), Error>) -> Void) {
        
        let urlString = "\(Constants.APIS.kBaseURL)/\(currency)?apikey=\(Constants.APIS.kApiKey5)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        completion(.success(priceString))
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            return nil
        }
    }
}
