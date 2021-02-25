//
//  BranchDetailVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 18/02/2021.
//

import UIKit

class BranchDetailVC: UICollectionViewCell {
    @IBOutlet weak private var create_at:UILabel!
    @IBOutlet weak private var voucherNo:UILabel!
    @IBOutlet weak private var user_email:UILabel!
    @IBOutlet weak private var inBalance:UILabel!
    @IBOutlet weak private var outBalance:UILabel!
    @IBOutlet weak private var balance:UILabel!
    @IBOutlet weak private var desc:UILabel!
    var tr:TranscationDataModel?{
        didSet{
            
            guard let t = tr else {return}
            let tu = checkTranscationCategory(category: t.category,foregroundColor: UIColor.red.cgColor)
            if tu.0 == IN
            {
                let mutableAttrString1 = NSMutableAttributedString()
                
                mutableAttrString1.append(tu.1)
                mutableAttrString1.append(makeAttributeString(myString: " Voucher", foregroundColor: UIColor.gray.cgColor))
                mutableAttrString1.append(makeAttributeString(myString: " \(t.voucher_no)", foregroundColor: UIColor.gray.cgColor))
                inBalance.text = "\(t.balance)"
                outBalance.text = nil
                balance.text = "\(t.total_balance)"
                desc.text = t.description
                user_email.text = t.user_email
                voucherNo.attributedText = mutableAttrString1
                create_at.text = TimeAndDateHelper.getServerDate(with: t.created_at)
            }
            else
            {
                let mutableAttrString1 = NSMutableAttributedString()
                
                mutableAttrString1.append(tu.1)
                mutableAttrString1.append(makeAttributeString(myString: " Voucher", foregroundColor: UIColor.gray.cgColor))
                mutableAttrString1.append(makeAttributeString(myString: " \(t.voucher_no)", foregroundColor: UIColor.gray.cgColor))
                outBalance.text = "\(t.balance)"
                inBalance.text = nil
                balance.text = "\(t.total_balance)"
                desc.text = t.description
                voucherNo.attributedText = mutableAttrString1
                user_email.text = t.user_email
                create_at.text = TimeAndDateHelper.getServerDate(with: t.created_at)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
