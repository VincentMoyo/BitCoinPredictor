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
    
    var database = DatabaseManager()
    var lineChart = LineChartView()
    var timer = Timer()
    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.delegateError = self
        timer.invalidate()
        updateTimer()
    }
    
    @IBAction func liveGraphChanged(_ sender: UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                         selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } else {
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        homeViewModel.updateTimer()
        DispatchQueue.main.async {
            self.bitCoinLabel.text = String(self.homeViewModel.priceData.price)
        }
        lineChart.delegate = self
    }
}

// MARK: - User Alerts
extension HomeViewController: ShowUserErrorDelegate {
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - Chart View Delegate section
extension HomeViewController: ChartViewDelegate {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setChartFrame()
        liveGraphView.addSubview(lineChart)
        
        let set = LineChartDataSet(entries: setChartEntries())
        setPropertiesOfSet(set)
        
        let data = LineChartData(dataSet: set)
        lineChart.data =  data
    }
    
    private func setChartFrame() {
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.liveGraphView.frame.size.width,
                                 height: self.liveGraphView.frame.size.height)
        lineChart.xAxis.drawLabelsEnabled = false
    }
    
    func setChartEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for price in homeViewModel.priceList {
            entries.append(ChartDataEntry(x: Double(price.date)!,
                                          y: Double(price.rate)!))
        }
        return entries
    }
    
    func setPropertiesOfSet(_ set: LineChartDataSet) {
        set.colors = ChartColorTemplates.liberty()
        set.drawValuesEnabled = false
        set.label = "Bitcoin Graph"
    }
}
