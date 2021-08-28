//
//  TransactionViewController.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import UIKit

class AddTransactionViewController: UIViewController {

    @IBOutlet var categoryPicker: UIPickerView!
    var pickerData: [String] = [String]()
    var choosedPickerCategory: String?
    
    @IBOutlet var name: UITextField!
    @IBOutlet var amount: UITextField!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var date: UITextField!
    
    var completion: ((Transaction) -> Void)?
    var isExpense: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.becomeFirstResponder()
        name.borderStyle = UITextField.BorderStyle.roundedRect
        amount.borderStyle = UITextField.BorderStyle.roundedRect
        date.borderStyle = UITextField.BorderStyle.roundedRect
        saveBtn.layer.cornerRadius = 15
        
        //Picker
        pickerData = ["Food and Drinks", "Appartment", "Vehicle", "Entertainment", "Electronics", "Investments", "Other"]
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    @IBAction func saveTransaction() {
        let amountDouble = Double(amount.text!)
        if !name.text!.isEmpty && amountDouble != 0 && !amount.text!.isEmpty
            && isDateValid(for: date.text!) {
            let transaction = Transaction(sum: amountDouble ?? 0, name: name.text!, date: date.text!, isExpense: self.isExpense, category: choosedPickerCategory!)
            completion?(transaction)
            
        }
        else {
            chooseAlertWindow()
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
    
    func isDateValid(for string: String) -> Bool {
        let pattern = "[0-3][0-9]/[0-1][0-9]/[0-9]{4}"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let matches = regex.matches(in: string, options: .reportProgress, range:NSRange(location: 0, length: string.count))
        
        return matches.count > 0 ? true: false
    }
    
    func chooseAlertWindow() {
        var titleOfAlert: String
        var messageOfAlert: String
        
        if !isDateValid(for: date.text!) {
            titleOfAlert = "Yoooo"
            messageOfAlert = "You need to enter valid date format"
        }
        else {
            titleOfAlert = "Bruh"
            messageOfAlert = "Fill every textfields with values"
        }
        let alert = UIAlertController(title: titleOfAlert, message: messageOfAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Gotcha", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedPickerCategory = pickerData[row]
    }
}
