//
//  AddUser.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 25/02/2021.
//

import UIKit

class AddUser: UIViewController {

    var business_Name = ""
    var branch_Name = ""
    var branch_Id = ""
    var business_Id = ""
    @IBOutlet weak private var businessName:UILabel!{
        didSet{
            businessName.text = business_Name
        }
    }
    @IBOutlet weak private var branchName:UILabel!
    @IBOutlet weak private var email:UITextField!
    var isBranch:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (isBranch != nil)
        {
            branchName.isHidden = false
            branchName.text = branch_Name
        }
        
    }
    
    @IBAction private func addUser(_ sender:UIButton)
    {
        if (isBranch != nil && email.text != ""){
            addUserTo(url: EndPoints.add_user_branch, para: ["email":email.text!,"business_id":business_Id,"id":branch_Id])
        }else if (isBranch == nil && email.text != ""){
            addUserTo(url: EndPoints.add_user_business, para: ["email":email.text!,"business_id":business_Id])
        }
    }
    
    
    private func addUserTo(url:String,para:[String:String]){
        guard let user = LocalData.getUser(), let _ = user.data.first?.id else {return}
        Toast.showActivity(superView: self.view)
        DataService.shared.addingStaff(urlPath: url, para:para)
        { (result) in
            switch result
            {
            case .success:
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self!.view)
                    Toast.showToast(superView: self!.view, message: "Saved")
                }
            case .failure(let er):
               
                if er.localizedDescription == "Create User"{
                    DispatchQueue.main.async {
                        Toast.dismissActivity(superView: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                            let vc = SignUp(nibName: "SignUp", bundle: nil)
                            vc.completed = {
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        Toast.dismissActivity(superView: self.view)
                        Toast.showToast(superView: self.view, message: er.localizedDescription)
                    }
                }
                
            }
        }
    }
}
