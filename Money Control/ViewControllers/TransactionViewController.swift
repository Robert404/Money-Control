//
//  TransactionViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 04.07.21.
//

import UIKit

class TransactionViewController: UIViewController {

    var transaction: Transaction!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .none
        
        nameLabel?.text = transaction.name
        dateLabel?.text = transaction.date
        sumLabel?.text = "$" + String(transaction.sum)
        categoryLabel?.text = transaction.category
        view.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
    }
}
