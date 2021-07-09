//
//  ComparisonViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/08.
//

import UIKit
import Charts
import FirebaseFirestore

class ComparisonViewController: TimerViewController {
    
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var predictedPricelLabel: UILabel!
    @IBOutlet weak var chartComparisonPrices: UIView!
    
    let priceData = PriceData()
    let dateClass = DateClass()
    let predictClass = PredictViewController()
    let db = Firestore.firestore()
    
    var predictedPrice = 0.0
    var predictedTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.invalidate()
        updateTimer()
    }
    
    override func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            apiClass.getAPI() { result in
                do {
                    let newPrice = try result.get()
                    DispatchQueue.main.async {
                        self.actualPriceLabel.text = newPrice
                        self.database.insertPriceToDatabase(newPrice)
                    }
                } catch {
                    print("there is an error \(error.localizedDescription)")
                }
            }
            database.loadPricesFromDatabse { result in
                do {
                    let newList = try result.get()
                    self.priceList = newList
                } catch {
                    print("there is an error \(error.localizedDescription)")
                }
            }
            database.loadPredictedPriceFromDatabase { result in
                do {
                    let newPredictedPrice = try result.get()
                    self.predictedPrice = Double(newPredictedPrice.price)!
                    self.predictedTime = Double(newPredictedPrice.date)!
                    DispatchQueue.main.async {
                        self.predictedPricelLabel.text = newPredictedPrice.price
                    }
                } catch {
                    print("there is an error \(error.localizedDescription)")
                }
            }
            lineChart.delegate = self
        }
        else{
            timerSeconds += 1
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        updateTimer()
    }
    
    @IBAction func liveGraphSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } else {
            timer.invalidate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.chartComparisonPrices.frame.size.width,
                                 height: self.chartComparisonPrices.frame.size.height)
        chartComparisonPrices.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        for price in priceList {
            entries.append(ChartDataEntry(x: Double(price.date)!,
                                          y: Double(price.rate)!))
        }
        let set2 = LineChartDataSet(entries: [
            ChartDataEntry(x: predictedTime, y: predictedPrice)
        ])
        let set = LineChartDataSet(entries: entries)
        
        set.colors = ChartColorTemplates.colorful()
        set2.highlightEnabled = true
        set2.highlightColor = .red
        set2.highlightLineWidth = 4
        set2.highlightLineDashLengths = [4,2]
        set2.drawHorizontalHighlightIndicatorEnabled = true
        set2.drawVerticalHighlightIndicatorEnabled = true
        let data = LineChartData(dataSet: set)
        data.addDataSet(set2)
        lineChart.data =  data
    }
}
