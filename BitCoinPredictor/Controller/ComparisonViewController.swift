//
//  ComparisonViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/08.
//

import UIKit
import Charts

class ComparisonViewController: UIViewController {
    
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var predictedPricelLabel: UILabel!
    @IBOutlet weak var chartComparisonPrices: UIView!
    
    let comparisonViewModel = ComparisonViewModel()
    let apiClass = BitcoinAPI()
    var database = DatabaseManager()
    lazy var timerSeconds = 0
    lazy var priceList: [PriceListModel] = []
    var lineChart = LineChartView()
    var timer = Timer()
    lazy var predictedPrice = 0.0
    lazy var predictedTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.delegateError = self
        timer.invalidate()
        updateTimer()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        updateTimer()
    }
    
    @IBAction func liveGraphSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                         selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } else {
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        comparisonViewModel.updateTimer()
        DispatchQueue.main.async {
            self.actualPriceLabel.text = String(self.comparisonViewModel.priceData.price)
            self.predictedPricelLabel.text = String(self.comparisonViewModel.predictedPriceData.currentPrice)
        }
        lineChart.delegate = self
    }
    
    func getBitcoinPrincUsingAPI() {
        apiClass.getAPI { result in
            do {
                let newPrice = try result.get()
                DispatchQueue.main.async {
                    self.actualPriceLabel.text = newPrice
                    self.database.insertPriceToDatabase(newPrice)
                }
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.showUserErrorMessageDidInitiate(message)
            }
        }
    }
    
    func loadPricesFromDatabse() {
        database.loadPricesFromDatabse { result in
            do {
                let newList = try result.get()
                self.priceList = newList
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.showUserErrorMessageDidInitiate(message)
            }
        }
    }
    
    func loadPredictedPricesFromDatabse() {
        database.loadPredictedPriceFromDatabase { result in
            do {
                let newPredictedPrice = try result.get()
                self.predictedPrice = Double(newPredictedPrice.price)!
                self.predictedTime = Double(newPredictedPrice.date)!
                DispatchQueue.main.async {
                    self.predictedPricelLabel.text = newPredictedPrice.price
                }
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.showUserErrorMessageDidInitiate(message)
            }
        }
    }
}

// MARK: - User Alert section
extension ComparisonViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - Chart View Delegate section
extension ComparisonViewController: ChartViewDelegate {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chartComparisonPrices.addSubview(lineChart)
        setChartFrame()
        let set = LineChartDataSet(entries: comparisonViewModel.setChartEntries())
        let set2 = LineChartDataSet(entries: [
            ChartDataEntry(x: comparisonViewModel.predictedPriceData.currentDate,
                           y: comparisonViewModel.predictedPriceData.currentPrice)
        ])
        
        comparisonViewModel.setPropertiesOfSet1(set)
        comparisonViewModel.setPropertiesOfSet2(set2)
        
        let data = LineChartData(dataSet: set)
        data.addDataSet(set2)
        lineChart.data =  data
    }
    
    private func setChartFrame() {
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.chartComparisonPrices.frame.size.width,
                                 height: self.chartComparisonPrices.frame.size.height)
        lineChart.xAxis.drawLabelsEnabled = false
    }
}
