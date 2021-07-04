//
//  TransactionViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var amount: UITextField!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var date: UITextField!
    
    var completion: ((Transaction) -> Void)?
    var isExpense: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        name?.becomeFirstResponder()
        name.borderStyle = UITextField.BorderStyle.roundedRect
        amount.borderStyle = UITextField.BorderStyle.roundedRect
        date.borderStyle = UITextField.BorderStyle.roundedRect
    }
    
    //TODO: Better alerts here
    @IBAction func saveTransaction() {
        let amountDouble = Double(amount.text!)
        if !name.text!.isEmpty && amountDouble != 0 && isDateVaid(for: date.text!) {
            let transaction = Transaction(sum: amountDouble ?? 0, name: name.text!, date: date.text!, type: "test", isExpense: self.isExpense)
            completion?(transaction)
            
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Please Enter required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Gotcha", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didChangeSegment(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            isExpense = false
        }
        else if segment.selectedSegmentIndex == 1 {
            isExpense = true
        }
    }
    
    func isDateVaid(for string: String) -> Bool {
        let pattern = "[0-3][0-9]/[0-1][0-9]/[0-9]{4}"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let matches = regex.matches(in: string, options: .reportProgress, range:NSRange(location: 0, length: string.count))
        
        return matches.count > 0 ? true: false
    }
}
