//
//  SignUp.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 18/02/2021.
//

import UIKit

class SignUp: UIViewController {

    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var password:UITextField!
    var completed:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    @IBAction private func signIn(_ sender:UIButton)
    {
        guard let emailText = email.text, let nam = name.text, nam != "", let passText = password.text, emailText != "" , passText != "" else
        {
            Toast.showToast(superView: self.view,message: "Please fill all fields")
            return
        }
        let para = ["email":emailText,
                    "password":passText,"name":nam]
        
        Toast.showActivity(superView: self.view)
        DataService.shared.addingStaff(urlPath: EndPoints.register, para: para) { (result) in
            switch result{
            case .success( _):
                DispatchQueue.main.async {
                    [unowned self] in
                    Toast.dismissActivity(superView: self.view)
                    Toast.showToast(superView: self.view, message: "Success")
                    completed?()
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
               
            case .failure(let er):
                DispatchQueue.main.async {
                    Toast.dismissActivity(superView: self.view)
                    Toast.showToast(superView: self.view, message: er.localizedDescription)
                }
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
