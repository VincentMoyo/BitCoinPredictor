//
//  ComparisonViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation
import Charts

class ComparisonViewModel {
    
    let apiClass = BitcoinAPI()
    let database = DatabaseManager()
    lazy var timerSeconds = 0
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    var predictedPriceData = PredictedPriceData()
    lazy var predictedPrice = 0.0
    lazy var predictedTime = 0.0
    var delegate: ShowUserErrorDelegate?
    
    func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            getBitcoinPrincUsingAPI()
            loadPricesFromDatabse()
            loadPredictedPricesFromDatabse()
        }
        else {
            timerSeconds += 1
        }
    }
    
    private func getBitcoinPrincUsingAPI() {
        apiClass.getAPI() { result in
            do {
                let newPrice = try result.get()
                self.database.insertPriceToDatabase(newPrice)
                self.priceData.price = Double(newPrice)!
                print("hwll;o")
            } catch {
                
            }
        }
    }
    
    func loadPredictedPricesFromDatabse(){
        database.loadPredictedPriceFromDatabase { result in
            do {
                let newPredictedPrice = try result.get()
                self.predictedPriceData.currentPrice = Double(newPredictedPrice.price)!
                self.predictedPriceData.currentDate = Double(newPredictedPrice.date)!
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.delegate!.showUserErrorMessageDidInitiate(message)
            }
        }
    }
    
    private func loadPricesFromDatabse(){
        database.loadPricesFromDatabse { result in
            do {
                let newList = try result.get()
                self.priceList = newList
            } catch {
                let message = "there is an error \(error.localizedDescription)"
                self.delegate!.showUserErrorMessageDidInitiate(message)
            }
        }
    }
    
    
    func setChartEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for price in priceList {
            entries.append(ChartDataEntry(x: Double(price.date)!,
                                          y: Double(price.rate)!))
        }
        return entries
    }
    
    func setPropertiesOfSet1(_ set: LineChartDataSet) {
        set.colors = ChartColorTemplates.colorful()
        set.drawValuesEnabled = false
    }
    
    func setPropertiesOfSet2(_ set2: LineChartDataSet) {
        set2.highlightEnabled = true
        set2.highlightColor = .red
        set2.highlightLineWidth = 4
        set2.highlightLineDashLengths = [4,2]
        set2.drawHorizontalHighlightIndicatorEnabled = true
        set2.drawVerticalHighlightIndicatorEnabled = true
    }
    
}
