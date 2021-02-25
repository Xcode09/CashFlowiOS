//
//  BusinessTypeCell.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 17/02/2021.
//

import UIKit

class BusinessTypeCell: UICollectionViewCell {

    @IBOutlet weak private var currenyLabel:UILabel!
    @IBOutlet weak private var totalBalance:UILabel!
    @IBOutlet weak private var businessName:UILabel!
    var model:BusinessesDataModel?{
        didSet{
            guard let dataModel = model else {return}
            totalBalance.text = "\(dataModel.balance)"
            businessName.text = dataModel.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
