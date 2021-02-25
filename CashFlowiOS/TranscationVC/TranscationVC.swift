//
//  TranscationVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 20/02/2021.
//

import UIKit

class TranscationVC: UIViewController {

    var selectCategory : Int?
    @IBOutlet weak var vocherImage:UIImageView!{
        didSet{
            vocherImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        }
    }
    
    @IBOutlet weak var vocherNumber:UITextField!
    @IBOutlet weak var particulars:UITextView!
    
    @IBOutlet weak var balanceView:UITextView!
    @IBOutlet weak var saleBtn:UIButton!{
        didSet{
            saleBtn.setCardView()
        }
    }
    
    @IBOutlet weak var bottomLabel:UILabel!{
        didSet{
            guard let user = LocalData.getUser(),
            let userEmail = user.data.first?.email
            else {return}
            bottomLabel.text = "Enter by:\n\(userEmail)"
        }
    }
    @IBOutlet weak var bottomTime:UILabel!{
        didSet{
            bottomTime.text = TimeAndDateHelper.getTime()
        }
    }
    @IBOutlet weak var topTime:UILabel!{
        didSet{
            topTime.text = TimeAndDateHelper.getTime()
        }
    }
    @IBOutlet weak var topDate:UILabel!{
        didSet{
            topDate.text = TimeAndDateHelper.getDate()
        }
    }
    @IBOutlet weak var receviedBtn:UIButton!{
        didSet{
            receviedBtn.setCardView()
        }
    }
    @IBOutlet weak var expenseBtn:UIButton!{
        didSet{
            expenseBtn.setCardView()
        }
    }
    @IBOutlet weak var sentBtn:UIButton!{
        didSet{
            sentBtn.setCardView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction private func categoryExpense(_ sender:UIButton)
    {
        selectCategory = sender.tag
        expenseBtn.layer.borderColor = UIColor.blue.cgColor
        saleBtn.setCardView()
        sentBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categorySale(_ sender:UIButton)
    {
        selectCategory = sender.tag
        saleBtn.layer.borderColor = UIColor.blue.cgColor
        expenseBtn.setCardView()
        sentBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categorySent(_ sender:UIButton)
    {
        selectCategory = sender.tag
        sentBtn.layer.borderColor = UIColor.blue.cgColor
        saleBtn.setCardView()
        expenseBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categoryReceved(_ sender:UIButton)
    {
        selectCategory = sender.tag
        receviedBtn.layer.borderColor = UIColor.blue.cgColor
        saleBtn.setCardView()
        sentBtn.setCardView()
        expenseBtn.setCardView()
    }
    
    @objc private func pickImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction private func saveBtn(_ sender:UIButton){
        guard let image = vocherImage.image,
              let vocherNumber = vocherNumber.text,
              vocherNumber != "",
              let particularText = particulars.text,
              let category = selectCategory,
              let balance = balanceView.text,
              let user = LocalData.getUser(),
              let userEmail = user.data.first?.email
        else {
            return Toast.showToast(superView: self.view, message: "Please fill all fields")
        }
        let para = [
            "category":"\(category)",
            "description":particularText,
            "voucher_no":vocherNumber,
            "branch_id":"6",
            "balance":"\(balance)",
            "email":"\(userEmail)",
            "password":"12345678"
        ]
        
        Toast.showActivity(superView: self.view)
        DataService.shared.uploadTranscation(urlPath: EndPoints.transcation, para: para, image:image) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [unowned self] in
                    Toast.dismissActivity(superView: self.view)
                    print(model)
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    [unowned self] in
                    Toast.dismissActivity(superView: self.view)
                    Toast.showToast(superView: self.view, message: er.localizedDescription)
                }
            }
        }
    }


}

extension TranscationVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return picker.dismiss(animated: true, completion: nil)
        }
        vocherImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}


extension UIButton{
    func setCardView(){
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.3
        layer.shadowColor = UIColor.lightText.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.6
    }
}
