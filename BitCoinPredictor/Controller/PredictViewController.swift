//
//  PredictViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/08.
//

import UIKit

class PredictViewController: UIViewController {
    
    var priceData = PredictedPriceData()
    var controller = CrementClass()
    let bitcoinAPI = BitcoinAPI()
    var database = DatabaseManager()
    
    lazy private var crementValue = 0.0
    lazy private var curent = 0.0
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var predictPriceLabel: UILabel!
    @IBOutlet weak var tenIncrementButton: UIButton!
    @IBOutlet weak var hundredIncrementButton: UIButton!
    @IBOutlet weak var thousandIncrementButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.delegateError = self
        database.delegateSucess = self
        getBitcoinPrincUsingAPI()
    }
    
    @IBAction func incrementPriceButtonPressed(_ sender: UIButton) {
        priceData.currentPrice = controller.incrementByInterval(priceData.currentPrice, crementValue, true)
        predictPriceLabel.text = String(priceData.currentPrice)
        curent = priceData.currentPrice
    }
    
    @IBAction func decrementPriceButtonPressed(_ sender: UIButton) {
        priceData.currentPrice = controller.incrementByInterval(priceData.currentPrice, crementValue, false)
        predictPriceLabel.text = String(priceData.currentPrice)
        curent = priceData.currentPrice
    }
    
    
    @IBAction func incrementChanged(_ sender: UIButton) {
        tenIncrementButton.isSelected = false
        hundredIncrementButton.isSelected = false
        thousandIncrementButton.isSelected = false
        sender.isSelected = true
        crementValue = Double(sender.currentTitle!)!
    }
    
    @IBAction func predictButtonPressed(_ sender: UIButton) {
        database.updatePredictedPriceIntoDatabase(String(curent))
    }
    
    func getBitcoinPrincUsingAPI() {
        bitcoinAPI.getAPI() { result in
            do {
                let newPrice = try result.get()
                DispatchQueue.main.async {
                    self.priceLabel.text = newPrice
                    self.priceData.currentPrice = Double(newPrice)!
                }
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.showUserErrorMessageDidInitiate(message)
            }
        }
    }
}

//MARK: - User Alerts
extension PredictViewController: showUserErrorDelegate, showUserSucessDelegate{
    
    func showUserSucessMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}

//MARK: - Increment and Decrement section
struct CrementClass {
    func incrementByInterval(_ byteCoinPrice: Double, _ incrementValue: Double, _ increment: Bool) -> Double{
        var finalPrice = 0.0
        if incrementValue > 0 {
            if (increment){
                finalPrice = byteCoinPrice + incrementValue
            } else {
                finalPrice = byteCoinPrice - incrementValue
            }
        }
        return finalPrice
    }
}