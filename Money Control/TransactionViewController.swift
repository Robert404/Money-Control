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
    override func viewDidLoad() {
        super.viewDidLoad()
        name?.becomeFirstResponder()
        name.borderStyle = UITextField.BorderStyle.roundedRect
        amount.borderStyle = UITextField.BorderStyle.roundedRect
        date.borderStyle = UITextField.BorderStyle.roundedRect
    }
    
    @IBAction func saveTransaction() {
        let amountDouble = Double(amount.text!)
        if !name.text!.isEmpty && amountDouble != 0 {
            let transaction = Transaction(sum: amountDouble ?? 0, name: name.text!, date: date.text!, type: "test")
            completion?(transaction)
            
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Please Enter required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Gotcha", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
