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
    var delegateError: ErrorReporting?
    var delegateSuccess: DisplayingSuccessMessage?
    
    // MARK: - Bytecoin Database
    
    func loadPrices(completion: @escaping (Result<[PriceArrayModel], Error>) -> Void) {
        database.collection(Constants.Database.kBitCoinDatabaseName)
            .order(by: Constants.Database.kDate)
            .addSnapshotListener { (querySnapshot, error) in
                var priceList: [PriceArrayModel] = []
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfBitcoin = data[Constants.Database.kRate] as? String,
                               let dateOfBitcoinPrice = data[Constants.Database.kDate] as? String {
                                let newPrice = PriceArrayModel(priceList: PriceArray(rate: priceOfBitcoin, date: dateOfBitcoinPrice))
                                priceList.append(newPrice)
                            }
                        }
                    }
                }
                completion(.success(priceList))
            }
    }
    
    func insertPrice(_ price: String) {
        database.collection(Constants.Database.kBitCoinDatabaseName).addDocument(data: [
            Constants.Database.kRate: price,
            Constants.Database.kDate: String(Date().timeIntervalSince1970)
        ]) { (error) in
            if let err = error {
                delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
            }
        }
    }
    
    // MARK: - Predicted Price Database
    
    func loadPredictedPrice(completion: @escaping (Result<(price: String, date: String), Error>) -> Void) {
        database.collection(Constants.Database.kPredictedPriceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                if let err = error {
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
    
    func updatePredictedPrice(_ predictedPrice: String, _ predictedDate: String) {
        database.collection(Constants.Database.kPredictedPriceDatabaseName)
            .document(Constants.Database.kPredictedPriceDocumentName)
            .updateData([
                Constants.Database.kPrice: predictedPrice,
                Constants.Database.kDate: predictedDate
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                }
            }
    }
    
    // MARK: - Account Balance Database
    
    func loadBalances(completion: @escaping (Result<[BalanceArrayModel], Error>) -> Void) {
        database.collection(Constants.Database.kBalanceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                var balanceList: [BalanceArrayModel] = []
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let newBalance = data[Constants.Database.kBalance] as? String,
                               let newEquity = data[Constants.Database.kEquity] as? String,
                               let newFreeMargin = data[Constants.Database.kFreeMargin] as? String,
                               let newBitcoin = data[Constants.Database.kBitcoin] as? String {
                                let newBalanceList = BalanceArrayModel(balanceList: BalanceArray(balance: newBalance,
                                                                                               equity: newEquity,
                                                                                               freeMargin: newFreeMargin,
                                                                                               bitcoin: newBitcoin))
                                balanceList.append(newBalanceList)
                            }
                        }
                    }
                }
                completion(.success(balanceList))
            }
    }
    
    func updateAccountBalance(_ balance: String, _ equity: String, _ freeMargin: String, _ bitcoin: String) {
        database.collection(Constants.Database.kBalanceDatabaseName)
            .document(Constants.Database.kBalanceDocumentName)
            .updateData([
                Constants.Database.kBalance: balance,
                Constants.Database.kEquity: equity,
                Constants.Database.kFreeMargin: freeMargin,
                Constants.Database.kBitcoin: bitcoin
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
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
