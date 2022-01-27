//
//  DatabaseManager.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/01.
//

import Foundation
import FirebaseFirestore

struct DatabaseManager {
    
    private let database: Firestore
    var delegateError: ErrorReporting?
    var delegateSuccess: DisplayingSuccessMessage?
    
    init(databaseReference: Firestore) {
        self.database = databaseReference
    }
    
    // MARK: - Bytecoin Database
    
    func loadPrices(completion: @escaping (Result<[PriceArrayModel], Error>) -> Void) {
        database.collection(Constants.Database.Bitcoin.kBitcoinDatabaseName)
            .order(by: Constants.Database.Bitcoin.kBitcoinDate)
            .addSnapshotListener { (querySnapshot, error) in
                var priceList: [PriceArrayModel] = []
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfBitcoin = data[Constants.Database.Bitcoin.kBitcoinRate] as? String,
                               let dateOfBitcoinPrice = data[Constants.Database.Bitcoin.kBitcoinDate] as? String {
                                let newPrice = PriceArrayModel(priceList: PriceArray(rate: priceOfBitcoin, date: dateOfBitcoinPrice))
                                priceList.append(newPrice)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(priceList))
                }
            }
    }
    
    func insertPrice(_ price: String) {
        database.collection(Constants.Database.Bitcoin.kBitcoinDatabaseName)
            .addDocument(data: [
                Constants.Database.Bitcoin.kBitcoinRate: price,
                Constants.Database.Bitcoin.kBitcoinDate: String(Date().timeIntervalSince1970)
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                }
            }
    }
    
    // MARK: - Predicted Price Database
    
    func loadPredictedPrice(completion: @escaping (Result<(price: String, date: String), Error>) -> Void) {
        database.collection(Constants.Database.PredictedPrice.kPredictedPriceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let priceOfByteCoin = data[Constants.Database.PredictedPrice.kPredictedPrice] as? String,
                               let date = data[Constants.Database.PredictedPrice.kPredictedPriceDate] as? String {
                                DispatchQueue.main.async {
                                completion(.success((priceOfByteCoin, date)))
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func updatePredictedPrice(_ predictedPrice: String, _ predictedDate: String) {
        database.collection(Constants.Database.PredictedPrice.kPredictedPriceDatabaseName)
            .document(Constants.Database.PredictedPrice.kPredictedPriceDocumentName)
            .updateData([
                Constants.Database.PredictedPrice.kPredictedPrice: predictedPrice,
                Constants.Database.PredictedPrice.kPredictedPriceDate: predictedDate
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
        database.collection(Constants.Database.AccountBalance.kBalanceDatabaseName)
            .addSnapshotListener { (querySnapshot, error) in
                var balanceList: [BalanceArrayModel] = []
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            if let newBalance = data[Constants.Database.AccountBalance.kBalance] as? String,
                               let newEquity = data[Constants.Database.AccountBalance.kEquity] as? String,
                               let newFreeMargin = data[Constants.Database.AccountBalance.kFreeMargin] as? String,
                               let newBitcoin = data[Constants.Database.AccountBalance.kBitcoin] as? String {
                                let newBalanceList = BalanceArrayModel(balanceList: BalanceArray(balance: newBalance,
                                                                                                 equity: newEquity,
                                                                                                 freeMargin: newFreeMargin,
                                                                                                 bitcoin: newBitcoin))
                                balanceList.append(newBalanceList)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                completion(.success(balanceList))
                }
            }
    }
    
    func updateAccountBalance(_ balance: String, _ equity: String, _ freeMargin: String, _ bitcoin: String) {
        database.collection(Constants.Database.AccountBalance.kBalanceDatabaseName)
            .document(Constants.Database.AccountBalance.kBalanceDocumentName)
            .updateData([
                Constants.Database.AccountBalance.kBalance: balance,
                Constants.Database.AccountBalance.kEquity: equity,
                Constants.Database.AccountBalance.kFreeMargin: freeMargin,
                Constants.Database.AccountBalance.kBitcoin: bitcoin
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                }
            }
    }
    
    // MARK: - Settings Database
    
    func loadUserSettings(SignedInUser userSetting: String, completion: @escaping (Result<[UserInformationModel], Error>) -> Void) {
        database.collection(Constants.Database.UserSettings.kUserInformationDatabaseName)
            .document(userSetting)
            .addSnapshotListener { (querySnapshot, error) in
                var userList: [UserInformationModel] = []
                if let err = error {
                    completion(.failure(err))
                } else {
                    if let snapshotDocument = querySnapshot {
                        if let data = snapshotDocument.data() {
                            if let newFirstName = data[Constants.Database.UserSettings.kFirstName] as? String,
                               let newLastName = data[Constants.Database.UserSettings.kLastName] as? String,
                               let newDateOfBirth = data[Constants.Database.UserSettings.kDateOfBirth] as? String,
                               let newGender = data[Constants.Database.UserSettings.kGender] as? String {
                                let newUserSettingsList = UserInformationModel(userInformation: UserInformationArray(firstName: newFirstName,
                                                                                                                     lastName: newLastName,
                                                                                                                     gender: newGender,
                                                                                                                     dateOfBirth: newDateOfBirth))
                                userList.append(newUserSettingsList)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                completion(.success(userList))
                }
            }
    }
    
    func createUserSettings(signInUser userID: String,
                            userFirstName firstName: String,
                            userLastName lastName: String,
                            userGender gender: String,
                            userDateOfBirth dateOfBirth: String) {
        database.collection(Constants.Database.UserSettings.kUserInformationDatabaseName)
            .document(userID)
            .setData([
                Constants.Database.UserSettings.kFirstName: firstName,
                Constants.Database.UserSettings.kLastName: lastName,
                Constants.Database.UserSettings.kGender: gender,
                Constants.Database.UserSettings.kDateOfBirth: dateOfBirth
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                }
            }
    }
    
    func updateUserSettingsFirstName(SignedInUser userSettingsID: String, username firstName: String) {
        database.collection(Constants.Database.UserSettings.kUserInformationDatabaseName)
            .document(userSettingsID)
            .updateData([
                Constants.Database.UserSettings.kFirstName: firstName
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                    
                }
            }
    }
    func updateUserSettingsLastName(SignedInUser userSettingsID: String, userLastName lastName: String) {
        database.collection(Constants.Database.UserSettings.kUserInformationDatabaseName)
            .document(userSettingsID)
            .updateData([
                Constants.Database.UserSettings.kLastName: lastName
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                    
                }
            }
    }
    func updateUserSettingsGender(SignedInUser userSettingsID: String, userGender gender: String) {
        database.collection(Constants.Database.UserSettings.kUserInformationDatabaseName)
            .document(userSettingsID)
            .updateData([
                Constants.Database.UserSettings.kGender: gender
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                    
                }
            }
    }
    func updateUserSettingsDateOfBirth(SignedInUser userSettingsID: String, DOB: String) {
        database.collection(Constants.Database.UserSettings.kUserInformationDatabaseName)
            .document(userSettingsID)
            .updateData([
                Constants.Database.UserSettings.kDateOfBirth: DOB
            ]) { (error) in
                if let err = error {
                    delegateError?.showUserErrorMessageDidInitiate(NSLocalizedString("FIREBASE_ERROR", comment: "") + "\(err)")
                } else {
                    delegateSuccess?.showUserSuccessMessageDidInitiate(NSLocalizedString("SUCCESS_DATA_SAVED", comment: ""))
                    
                }
            }
    }
}
