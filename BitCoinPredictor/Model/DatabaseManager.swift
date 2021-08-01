//
//  DatabaseManager.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/01.
//

import Foundation
import FirebaseFirestore

struct DatabaseManager {
    
    private let database = Firestore.firestore()
    var delegateError: ShowUserErrorDelegate?
    var delegateSucess: ShowUserSucessDelegate?
    
// MARK: - Bytecoin Database
    
    func loadPricesFromDatabse(completion: @escaping (Result<[PriceListModel], Error>) -> Void) {
        database.collection(Constants.Database.kBitCoinDatabaseName)
            .order(by: Constants.Database.kDate)
            .addSnapshotListener { (querySnapshot, error) in
                var priceList: [PriceListModel] = []
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data[Constants.Database.kRate] as? String,
                               let date = data[Constants.Database.kDate] as? String {
                                let newPrice = PriceListModel(priceList: PriceList(rate: priceOfByteCoin, date: date))
                                priceList.append(newPrice)
                            }
                        }
                    }
                }
                completion(.success(priceList))
            }
    }
    
    func insertPriceToDatabase(_ price: String) {
        database.collection(Constants.Database.kBitCoinDatabaseName).addDocument(data: [
            Constants.Database.kRate: price,
            Constants.Database.kDate: String(Date().timeIntervalSince1970)
        ]) { (error) in
            if let err = error {
                let message = "There was an issue with Firestore, \(err)"
                delegateError?.showUserErrorMessageDidInitiate(message)
            } else {
                print("Successfully saved data")
            }
        }
    }
    
// MARK: - Predicted Price Database
    
    func loadPredictedPriceFromDatabase(completion: @escaping (Result<(price: String, date: String), Error>) -> Void) {
        database.collection(Constants.Database.kPredictedPriceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                if let err = error {
                    let message = "There was an issue retrieving data from firestorem: \(err)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data[Constants.Database.kPrice] as? String,
                               let date = data[Constants.Database.kDate] as? String {
                                completion(.success((priceOfByteCoin, date)))
                            }
                        }
                    }
                }
            }
    }
    
    func updatePredictedPriceIntoDatabase(_ predictedPrice: String) {
        
        database.collection(Constants.Database.kPredictedPriceDatabaseName)
            .document(Constants.Database.kPredictedPriceDocumentName)
            .updateData([
                Constants.Database.kPrice: predictedPrice
            ]) { (error) in
                if let err = error {
                    let message = "There was an issue with Firestore, \(err)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                } else {
                    let message = "Successfully saved data"
                    delegateSucess?.showUserSucessMessageDidInitiate(message)
                }
            }
    }
    
    func updatePredictedDateIntoDatabase(_ predictedDate: String) {
        
        database.collection(Constants.Database.kPredictedPriceDatabaseName)
            .document(Constants.Database.kPredictedPriceDocumentName)
            .updateData([
                Constants.Database.kDate: predictedDate
            ]) { (error) in
                if let err = error {
                    let message = "There was an issue with Firestore, \(err)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                } else {
                    let message = "Successfully saved data"
                    delegateSucess?.showUserSucessMessageDidInitiate(message)
                }
            }
    }
    
// MARK: - Account Balance Database
    
    func loadBalanceFromDatabase(completion: @escaping (Result<[BalanceListModel], Error>) -> Void) {
        database.collection(Constants.Database.kBalanceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                var balanceList: [BalanceListModel] = []
                if let err = error {
                    let message = "There was an issue retrieving data from firestorem: \(err)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let newBalance = data[Constants.Database.kBalance] as? String,
                               let newEquity = data[Constants.Database.kEquity] as? String,
                               let newFreeMargin = data[Constants.Database.kFreeMargin] as? String,
                               let newBitcoin = data[Constants.Database.kBitboin] as? String {
                                let newBalanceList = BalanceListModel(balanceList: BalanceList(balance: newBalance,
                                                                                               equity: newEquity,
                                                                                               freemargin: newFreeMargin,
                                                                                               bitcoin: newBitcoin))
                                balanceList.append(newBalanceList)
                            }
                        }
                    }
                }
                completion(.success(balanceList))
            }
    }
    
    func updateAccountBalceDatabase(_ balance: String, _ equity: String, _ freeMargin: String, _ bitcoin: String) {
        database.collection(Constants.Database.kBalanceDatabaseName)
            .document(Constants.Database.kBalanceDocumentName)
            .updateData([
                Constants.Database.kBalance: balance,
                Constants.Database.kEquity: equity,
                Constants.Database.kFreeMargin: freeMargin,
                Constants.Database.kBitboin: bitcoin
            ]) { (error) in
                if let err = error {
                    let message = "There was an issue with Firestore, \(err)"
                    delegateError?.showUserErrorMessageDidInitiate(message)
                } else {
                    let message = "Successfully saved data"
                    delegateSucess?.showUserSucessMessageDidInitiate(message)
                }
            }
    }
            
}

// MARK: - Create PredictedPriceTable

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
