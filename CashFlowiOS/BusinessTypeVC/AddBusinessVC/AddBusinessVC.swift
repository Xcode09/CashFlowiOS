//
//  AddBusinessVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 19/02/2021.
//

import UIKit

class AddBusinessVC: UIViewController {

    @IBOutlet weak private var businessName:UITextField!
    var completed:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction private func saveBtn(_ sender:UIButton){
        guard let name = businessName.text, name != "",
              let us_id = LocalData.getUserID()
        else{
            Toast.showToast(superView: self.view, message: "Please enter business name")
            return
        }
        Toast.showActivity(superView: self.view)
        DataService.shared.generalApiForAddingStaff(urlPath: EndPoints.business, para: ["name":name,"user_id":"\(us_id)"]) { (result) in
            switch result{
            case .success:
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self?.view ?? UIView())
                    self?.completed?()
                    self?.dismiss(animated: true, completion: nil)
                    //self?.collectionView.reloadData()
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
