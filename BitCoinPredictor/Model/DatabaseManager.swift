//
//  DatabaseManager.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/01.
//

import Foundation
import FirebaseFirestore

struct DatabaseManager {
    
    let db = Firestore.firestore()
    
    func loadPricesFromDatabse(completion: @escaping (Result<[PriceList],Error>) -> Void) {
        db.collection("ByteCoins")
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
                var priceList: [PriceList] = []
                if let e = error {
                    print("There was an issue retrieving data from firestorem: \(e)")
                    completion(.failure(e))
                } else {
                    if let snapshotDocument = querySnapshot?.documents{
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data["rate"] as? String, let date = data["date"] as? String {
                                let newPrice = PriceList(rate: priceOfByteCoin, date: date)
                                priceList.append(newPrice)
                            }
                        }
                    }
                }
                completion(.success(priceList))
            }
    }
    
    func loadPredictedPriceFromDatabase(completion: @escaping (Result<(price: String, date: String),Error>) -> Void) {
        db.collection("PredictedPricesDatabase")
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from firestorem: \(e)")
                    completion(.failure(e))
                } else {
                    if let snapshotDocument = querySnapshot?.documents{
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data["price"] as? String, let date = data["date"] as? String{
                                completion(.success((priceOfByteCoin,date)))
                            }
                        }
                    }
                }
            }
    }
    
    func updatePredictedPriceIntoDatabase(_ predictedPrice: String) {
        db.collection("PredictedPricesDatabase").document("prices").updateData([
            "price": predictedPrice,
            "date": String(Date().timeIntervalSince1970 + 30)
        ])
        { (error) in
            if let e = error {
                print("There was an issue with Firestore, \(e)")
            } else {
                print("Successfully saved data")
            }
        }
    }
    
    func insertPriceToDatabase(_ price: String) {
        db.collection("ByteCoins").addDocument(data: [
            "rate": price,
            "date": String(Date().timeIntervalSince1970)
        ]) { (error) in
            if let e = error {
                print("There was an issue with Firestore, \(e)")
            } else {
                print("Successfully saved data")
            }
        }
    }
}




//MARK: - Create PredictedPriceTable

//        db.collection("PredictedPricesDatabase").document("prices").setData([
//            "price":predictedPrice,
//            "date":String(Date().timeIntervalSince1970 + 10)
//        ]) { (error) in
//            if let e = error {
//                print("There was an issue with Firestore, \(e)")
//            } else {
//                print("Successfully saved data")
//            }
//        }
