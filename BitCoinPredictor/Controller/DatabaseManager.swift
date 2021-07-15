//
//  DatabaseManager.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/01.
//

import Foundation
import FirebaseFirestore



struct DatabaseManager {
    
    private let db = Firestore.firestore()
    var delegateError: showUserErrorDelegate?
    var delegateSucess: showUserSucessDelegate?
    
    
    func loadPricesFromDatabse(completion: @escaping (Result<[PriceListModel],Error>) -> Void) {
        db.collection(K.Database.BitCoinDatabaseName)
            .order(by: K.Database.date)
            .addSnapshotListener { (querySnapshot, error) in
                var priceList: [PriceListModel] = []
                if let e = error {
                    let message = "There was an issue retrieving data from firestorem: \(e)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                    completion(.failure(e))
                } else {
                    if let snapshotDocument = querySnapshot?.documents{
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data[K.Database.rate] as? String, let date = data[K.Database.date] as? String {
                                let newPrice = PriceListModel(priceList: PriceList(rate: priceOfByteCoin, date: date))
                                priceList.append(newPrice)
                            }
                        }
                    }
                }
                completion(.success(priceList))
            }
    }
    
    func loadPredictedPriceFromDatabase(completion: @escaping (Result<(price: String, date: String),Error>) -> Void) {
        db.collection(K.Database.PredictedPriceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    let message = "There was an issue retrieving data from firestorem: \(e)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                    completion(.failure(e))
                } else {
                    if let snapshotDocument = querySnapshot?.documents{
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data[K.Database.price] as? String, let date = data[K.Database.date] as? String{
                                completion(.success((priceOfByteCoin,date)))
                            }
                        }
                    }
                }
            }
    }
    
    func updatePredictedPriceIntoDatabase(_ predictedPrice: String) {
        
        db.collection(K.Database.PredictedPriceDatabaseName).document(K.Database.PredictedPriceDocumentName).updateData([
            K.Database.price: predictedPrice,
            K.Database.date: String(Date().timeIntervalSince1970 + 30)
        ])
        { (error) in
            if let e = error {
                let message = "There was an issue with Firestore, \(e)"
                delegateError?.showUserErrorMessageDidInitiate(message)
            } else {
                let message = "Successfully saved data"
                delegateSucess?.showUserSucessMessageDidInitiate(message)
            }
        }
    }
    
    func insertPriceToDatabase(_ price: String) {
        db.collection(K.Database.BitCoinDatabaseName).addDocument(data: [
            K.Database.rate: price,
            K.Database.date: String(Date().timeIntervalSince1970)
        ]) { (error) in
            if let e = error {
                let message = "There was an issue with Firestore, \(e)"
                delegateError?.showUserErrorMessageDidInitiate(message)
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
