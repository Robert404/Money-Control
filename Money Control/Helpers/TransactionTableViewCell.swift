//
//  TransactionTableViewCell.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import Foundation
import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var sum: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
