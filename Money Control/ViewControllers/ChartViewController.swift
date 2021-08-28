//
//  ChartViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 27.08.21.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet var chart: PieChartView!

    var foodAndDrinks = PieChartDataEntry(value: 0)
    var appartment = PieChartDataEntry(value: 0)
    var vehicle = PieChartDataEntry(value: 0)
    var entertainment = PieChartDataEntry(value: 0)
    var electronics = PieChartDataEntry(value: 0)
    var investments = PieChartDataEntry(value: 0)
    var other = PieChartDataEntry(value: 0)
    
    var downloadedDataEnries = [PieChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        getTransactions()
        whatDataToShow()
        
        updateChartData()
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: downloadedDataEnries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemYellow,
                      UIColor.systemGray, UIColor.systemGreen, UIColor.systemPink,
                      UIColor.systemTeal, UIColor.systemPurple]
        chartDataSet.colors = colors
        
        chart.data = chartData
    }
    
    //if category is null -- don't show labels and zeros
    func whatDataToShow() {
        if foodAndDrinks.value != 0 {
            downloadedDataEnries.append(foodAndDrinks)
            foodAndDrinks.label = "Food and Drinks"
        }
        if appartment.value != 0 {
            downloadedDataEnries.append(appartment)
            appartment.label = "Appartment"
        }
        if vehicle.value != 0 {
            downloadedDataEnries.append(vehicle)
            vehicle.label = "Vehicle"
        }
        if entertainment.value != 0 {
            downloadedDataEnries.append(entertainment)
            entertainment.label = "Entertainment"
        }
        if electronics.value != 0 {
            downloadedDataEnries.append(electronics)
            electronics.label = "Electronics"
        }
        if investments.value != 0 {
            downloadedDataEnries.append(investments)
            investments.label = "Investments"
        }
        if other.value != 0 {
            downloadedDataEnries.append(other)
            other.label = "Other"
        }
    }

    
    func getTransactions() {
        guard
            let data = UserDefaults.standard.data(forKey: "items"),
            let savedItems = try? JSONDecoder().decode([Transaction].self, from: data)
        else { return }
        
        for item in savedItems {
            switch item.category {
            case "Food and Drinks":
                foodAndDrinks.value = item.sum
            case "Appartment":
                appartment.value = item.sum
            case "Vehicle":
                vehicle.value = item.sum
            case "Entertainment":
                entertainment.value = item.sum
            case "Electronics":
                electronics.value = item.sum
            case "Investments":
                investments.value = item.sum
            case "Other":
                other.value = item.sum
            default:
                print("None")
            }
        }
    }
}
