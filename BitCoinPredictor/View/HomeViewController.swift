//
//  ViewController.swift
//  ByteCoinPredictor
//
//  Created by Vincent Moyo on 2021/06/04.
//

import UIKit
import Charts

class HomeViewController: TimerViewController {
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var chartViewPrices: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            apiClass.getAPI() { result in
                do {
                    let newPrice = try result.get()
                    DispatchQueue.main.async {
                        self.database.insertPriceToDatabase(newPrice)
                        self.bitCoinLabel.text = newPrice
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
            lineChart.delegate = self
        }
        else{
            timerSeconds += 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lineChart.frame = CGRect(x: 0, y: 0,
                                 width: self.chartViewPrices.frame.size.width,
                                 height: self.chartViewPrices.frame.size.width)
        lineChart.center = chartViewPrices.center
        view.addSubview(lineChart)
        var entries = [ChartDataEntry]()
        for price in priceList {
            entries.append(ChartDataEntry(x: Double(price.date)!,
                                          y: Double(price.rate)!))
        }
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.liberty()
        set.drawValuesEnabled = false
        lineChart.xAxis.drawLabelsEnabled = false
        let data = LineChartData(dataSet: set)
        lineChart.data =  data
    }
}
