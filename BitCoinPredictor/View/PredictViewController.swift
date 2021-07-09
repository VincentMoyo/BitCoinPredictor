//
//  PredictViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/08.
//

import UIKit
import FirebaseFirestore

class PredictViewController: TimerViewController {
    
    var priceData = PriceData()
    var controller = CrementClass()
    let db = Firestore.firestore()
    
    private var crementValue = 0.0
    private var curent = 0.0
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var predictPriceLabel: UILabel!
    @IBOutlet weak var tenIncrementButton: UIButton!
    @IBOutlet weak var hundredIncrementButton: UIButton!
    @IBOutlet weak var thousandIncrementButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClass.getAPI() { result in
            do {
                let newPrice = try result.get()
                DispatchQueue.main.async {
                    self.priceLabel.text = newPrice
                    self.priceData.currentPrice = Double(newPrice)!
                }
            } catch {
                print("there is an error \(error.localizedDescription)")
            }
        }
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
}
