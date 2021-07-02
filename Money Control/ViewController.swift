//
//  ViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var totalMoney: UILabel!
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
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        cell.name.text = transactions[indexPath.row].name
        cell.sum.text = String(transactions[indexPath.row].sum)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.remove(at: indexPath.row)
            table.reloadData()
            saveItems()
        }
    }
    
    private func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: "items"),
            let savedItems = try? JSONDecoder().decode([Transaction].self, from: data)
        else { return }

        self.transactions = savedItems
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encodedData, forKey: "items")
        }
    }
}

