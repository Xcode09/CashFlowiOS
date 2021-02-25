//
//  HeaderCell.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 17/02/2021.
//

import UIKit

class HeaderCell: UICollectionReusableView {

    @IBOutlet weak var busineeName:UILabel!
    @IBOutlet weak var adminPowerBtn:UIButton!{
        didSet{
            adminPowerBtn.isHidden = false
        }
    }
    @IBOutlet weak var reportBtn:UIButton!
    @IBOutlet weak var balance:UILabel!
    var isAdmin:Bool?{
        didSet{
            adminPowerBtn.isHidden = false
        }
    }
    
    var showBusinessUserTapped:(()->Void)?
    var showReportTapped:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func showBusinessUsers(_ sender:UIButton)
    {
        showBusinessUserTapped?()
    }
    @IBAction private func showReports(_ sender:UIButton)
    {
        showReportTapped?()
    }
    
}
