//
//  SignIn.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 18/02/2021.
//

import UIKit

class SignIn: UIViewController {

    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var password:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction private func signIn(_ sender:UIButton){
        
        guard let emailText = email.text, let passText = password.text, emailText != "" , passText != "" else
        {
            Toast.showToast(superView: self.view,message: "Please fill all fields")
            return
        }
        let para = ["email":emailText,
                    "password":passText]
        
        DataService.shared.login(urlPath: EndPoints.login, para: para) { (result) in
            switch result{
            case .success( _):
                DispatchQueue.main.async {
                    let window = (UIApplication.shared.delegate as! AppDelegate).window!
                    let businessType = BusinessTypeVC(nibName: "BusinessTypeVC", bundle: nil)
                    let nav = UINavigationController(rootViewController: businessType)
                    nav.navigationBar.prefersLargeTitles = true
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                }
               
            case .failure(let er):
                print(er)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
