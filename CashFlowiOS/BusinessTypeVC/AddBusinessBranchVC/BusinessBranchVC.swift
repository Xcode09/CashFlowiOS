//
//  BusinessBranchVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 19/02/2021.
//

import UIKit

class BusinessBranchVC: UIViewController {

    @IBOutlet weak private var balance:UITextField!
    @IBOutlet weak private var branchName:UITextField!
    var business_Name = ""
    var business_Id = ""
    @IBOutlet weak private var businessName:UILabel!{
        didSet{
            businessName.text = business_Name
        }
    }
    //@IBOutlet weak private var branchName:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction private func saveBtn(_ sender:UIButton){
        guard let name = branchName.text,
              let balance = balance.text,
              let _ = LocalData.getUserID()
        else{
            Toast.showToast(superView: self.view, message: "Please enter business name or balance")
            return
        }
        Toast.showActivity(superView: self.view)
        DataService.shared.generalApiForAddingStaff(urlPath: EndPoints.add_branch, para: ["balance":balance,"name":name,"business_type_id":business_Id,"user_id":"\(ADMIN)"]) { (result) in
            switch result{
            case .success:
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self?.view ?? UIView())
                    Toast.showToast(superView: self?.view ?? UIView(), message: "Added..")
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    Toast.dismissActivity(superView: self.view)
                    Toast.showToast(superView: self.view, message: er.localizedDescription)
                }
            }
        }
    }

}
