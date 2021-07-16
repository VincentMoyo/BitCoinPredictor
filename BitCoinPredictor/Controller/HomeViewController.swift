//
//  ViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/04.
//

import UIKit
import Charts
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var chartViewPrices: UIView!
    @IBOutlet weak var liveGraphView: UIView!
    
    let bitcoinAPI = BitcoinAPI()
    var database = DatabaseManager()
    lazy var timerSeconds = 0
    var priceList: [PriceListModel] = []
    var lineChart = LineChartView()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.delegateError = self
        timer.invalidate()
        updateTimer()
    }
    
    @IBAction func liveGraphChanged(_ sender: UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } else {
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            getBitcoinPrincUsingAPI()
            loadPricesFromDatabse()
            lineChart.delegate = self
        }
        else{
            timerSeconds += 1
        }
    }
    
    func getBitcoinPrincUsingAPI() {
        bitcoinAPI.getAPI() { result in
            do {
                let newPrice = try result.get()
                DispatchQueue.main.async {
                    self.database.insertPriceToDatabase(newPrice)
                    self.bitCoinLabel.text = newPrice
                }
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.showUserErrorMessageDidInitiate(message)
            }
        }
    }
    
    func loadPricesFromDatabse(){
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
}

//MARK: - User Alerts 
extension HomeViewController :showUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}

//MARK: - Chart View Delegate section
extension HomeViewController: ChartViewDelegate{
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setChartFrame()
        liveGraphView.addSubview(lineChart)
        
        let set = LineChartDataSet(entries: setChartEntries())
        setPropertiesOfSet(set)
        
        let data = LineChartData(dataSet: set)
        lineChart.data =  data
    }
    
    private func setChartEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for price in priceList {
            entries.append(ChartDataEntry(x: Double(price.date)!,
                                          y: Double(price.rate)!))
        }
        return entries
    }
    
    private func setPropertiesOfSet(_ set: LineChartDataSet) {
        set.colors = ChartColorTemplates.liberty()
        set.drawValuesEnabled = false
    }
    
    private func setChartFrame() {
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.liveGraphView.frame.size.width,
                                 height: self.liveGraphView.frame.size.height)
        lineChart.xAxis.drawLabelsEnabled = false
    }
}
