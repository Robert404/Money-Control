//
//  ViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var totalSumLabel: UILabel!
    @IBOutlet var incomeLabel: UILabel!
    @IBOutlet var expenseLabel: UILabel!
    @IBOutlet var table: UITableView!
    
    
    var transactions: [Transaction] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        getItems()
        table.delegate = self
        table.dataSource = self

        resetDataIfNewMonth()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        table.reloadData()
    }
    
    @IBAction func addItem() {
        guard let vc = storyboard?.instantiateViewController(identifier: "transactionVC") as? AddTransactionViewController else { return }
        vc.title = "New Transaction"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { transaction in
            self.navigationController?.popToRootViewController(animated: true)
            self.transactions.append(transaction)
            self.table.isHidden = false
            self.saveItems()
            self.calculateTotalMoney(transactionSum: transaction.sum, isExpence: transaction.isExpense)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: "items"),
            let savedItems = try? JSONDecoder().decode([Transaction].self, from: data)
        else { return }

        self.transactions = savedItems
        var income  = 0.0
        var expense = 0.0
        
        for transaction in transactions {
            switch transaction.isExpense {
            case true:
                expense += transaction.sum
            case false:
                income += transaction.sum
            }
        }
        let totalBalance = income - expense
        
        incomeLabel.text = (income == 0.0) ? "$0" : "$\(income)"
        expenseLabel.text = (expense == 0.0) ? "$0" : "$\(expense)"
        totalSumLabel.text = (totalBalance == 0.0) ? "$0" : "$\(totalBalance)"
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encodedData, forKey: "items")
        }
    }
    
    func resetDataIfNewMonth() {
        if getCurrentDay() == "1" {
            transactions.removeAll()
            saveItems()
        }
    }
    
    func getCurrentDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let dayOfTheMonth = dateFormatter.string(from: date)
        return dayOfTheMonth
    }
    
    private func calculateTotalMoney(transactionSum: Double, isExpence: Bool) {
        var updatedTotal = 0.0
        var income = 0.0
        var expense = 0.0

        let totalMoney = totalSumLabel.text?.replacingOccurrences(of: "$", with: "")
        let incomeMoney = incomeLabel.text?.replacingOccurrences(of: "$", with: "")
        let expenseMoney = expenseLabel.text?.replacingOccurrences(of: "$", with: "")

        if isExpence {
            updatedTotal = Double(totalMoney!)! - transactionSum
            expense = Double(expenseMoney!)! + transactionSum
            expenseLabel.text = "$" + String(expense)
        } else {
            updatedTotal = Double(totalMoney!)! + transactionSum
            income = Double(incomeMoney!)! + transactionSum
            incomeLabel.text = "$" + String(income)
        }
        totalSumLabel.text = "$" + String(updatedTotal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "transactionScreen":
            if let indexPath = table.indexPathForSelectedRow {
                let destinationController = segue.destination as! TransactionViewController
                destinationController.transaction = transactions[indexPath.row]
            }
        default:
            break
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        cell.name.text = transactions[indexPath.row].name
        cell.sum.text = "$" + String(transactions[indexPath.row].sum)
        cell.date.text = String(transactions[indexPath.row].date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let totalMoney = totalSumLabel.text?.replacingOccurrences(of: "$", with: "")
            let incomeMoney = incomeLabel.text?.replacingOccurrences(of: "$", with: "")
            let expenseMoney = expenseLabel.text?.replacingOccurrences(of: "$", with: "")
            
            let deletedTransaction = transactions.remove(at: indexPath.row)
            switch deletedTransaction.isExpense {
            case true:
                let updatedTotal = Double(totalMoney!)! + deletedTransaction.sum
                let updatedExpence = Double(expenseMoney!)! - deletedTransaction.sum
                expenseLabel.text! = "$" + String(updatedExpence)
                totalSumLabel.text! = "$" + String(updatedTotal)
            case false:
                let updatedTotal = Double(totalMoney!)! - deletedTransaction.sum
                let updatedIncome = Double(incomeMoney!)! - deletedTransaction.sum
                incomeLabel.text! = "$" + String(updatedIncome)
                totalSumLabel.text! = "$" + String(updatedTotal)
            }
            table.reloadData()
            saveItems()
        }
    }
}
