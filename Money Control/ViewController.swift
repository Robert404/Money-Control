//
//  ViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var totalSum: UILabel!
    @IBOutlet var incomeSum: UILabel!
    @IBOutlet var expenseSum: UILabel!
    @IBOutlet var table: UITableView!
    
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        getItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.table.reloadData()
    }
    
    @IBAction func addItem() {
        guard let vc = storyboard?.instantiateViewController(identifier: "transactionVC") as? TransactionViewController else { return }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //to add TransactionViewController
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
    
    //TODO: Cleanup this method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let totalMoney = totalSum.text?.replacingOccurrences(of: "$", with: "")
            let incomeMoney = incomeSum.text?.replacingOccurrences(of: "$", with: "")
            let expenseMoney = expenseSum.text?.replacingOccurrences(of: "$", with: "")
            
            let deletedTransition = transactions.remove(at: indexPath.row)
            switch deletedTransition.isExpense {
            case true:
                let updatedTotal = Double(totalMoney!)! + deletedTransition.sum
                let updatedExpence = Double(expenseMoney!)! - deletedTransition.sum
                expenseSum.text! = "$" + String(updatedExpence)
                totalSum.text! = "$" + String(updatedTotal)
            case false:
                let updatedTotal = Double(totalMoney!)! - deletedTransition.sum
                let updatedIncome = Double(incomeMoney!)! - deletedTransition.sum
                incomeSum.text! = "$" + String(updatedIncome)
                totalSum.text! = "$" + String(updatedTotal)
            }
            table.reloadData()
            saveItems()
        }
    }
    
    //TODO: cleanup this method
    private func calculateTotalMoney(transactionSum: Double, isExpence: Bool) {
        var updatedTotal = 0.0
        var income = 0.0
        var expense = 0.0

        let totalMoney = totalSum.text?.replacingOccurrences(of: "$", with: "")
        let incomeMoney = incomeSum.text?.replacingOccurrences(of: "$", with: "")
        let expenseMoney = expenseSum.text?.replacingOccurrences(of: "$", with: "")

        if isExpence {
            updatedTotal = Double(totalMoney!)! - transactionSum
            expense = Double(expenseMoney!)! + transactionSum
            expenseSum.text = "$" + String(expense)
        } else {
            updatedTotal = Double(totalMoney!)! + transactionSum
            income = Double(incomeMoney!)! + transactionSum
            incomeSum.text = "$" + String(income)
        }
        totalSum.text = "$" + String(updatedTotal)
    }
    
    //TODO: cleanup
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
        
        incomeSum.text = (income == 0.0) ? "$0" : "$\(income)"
        expenseSum.text = (expense == 0.0) ? "$0" : "$\(expense)"
        totalSum.text = (totalBalance < 0) ? "ー$\(-totalBalance)" : "$\(totalBalance)"
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encodedData, forKey: "items")
        }
    }
}

