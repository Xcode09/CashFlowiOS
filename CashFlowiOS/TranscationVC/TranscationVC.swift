//
//  TranscationVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 20/02/2021.
//

import UIKit

class TranscationVC: UIViewController {

    var selectCategory : Int?
    var branch_id = ""
    @IBOutlet weak var vocherImage:UIImageView!{
        didSet{
            vocherImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        }
    }
    
    @IBOutlet weak var vocherNumber:UITextField!
    @IBOutlet weak var particulars:UITextView!{
        didSet{
            particulars.applyCardView()
        }
    }
    
    @IBOutlet weak var balanceView:UITextView!{
        didSet{
            balanceView.applyCardView()
        }
    }
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
    @IBOutlet weak var inOut:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Add Transcation"
    }
    @IBAction private func categoryExpense(_ sender:UIButton)
    {
        selectCategory = sender.tag
        inOut.text = "OUT"
        expenseBtn.setState()
        saleBtn.setCardView()
        sentBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categorySale(_ sender:UIButton)
    {
        selectCategory = sender.tag
        inOut.text = "IN"
        saleBtn.setState(color: .white, backClr: UIColor(named: "INCLR")!)
        expenseBtn.setCardView()
        sentBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categorySent(_ sender:UIButton)
    {
        selectCategory = sender.tag
        inOut.text = "OUT"
        sentBtn.setState()
        saleBtn.setCardView()
        expenseBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categoryReceved(_ sender:UIButton)
    {
        selectCategory = sender.tag
        inOut.text = "IN"
        receviedBtn.setState(color: .white, backClr: UIColor(named: "INCLR")!)
        
        saleBtn.setCardView()
        sentBtn.setCardView()
        expenseBtn.setCardView()
    }
    
    @objc private func pickImage(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction private func saveBtn(_ sender:UIButton){
        guard let particularText = particulars.text,
              let category = selectCategory,
              let balance = balanceView.text,
              let user = LocalData.getUser(),
              let userEmail = user.data.first?.email,
              let pass = LocalData.getUserPassword()
        else {
            return Toast.showToast(superView: self.view, message: "Please fill all fields")
        }
        var para = [String:String]()
        if vocherNumber.text == nil {
            para = [
                "category":"\(category)",
                "description":particularText,
                "branch_id":branch_id,
                "balance":"\(balance)",
                "email":"\(userEmail)",
                "password":pass
            ]
        }
        else
        {
            para = [
                "category":"\(category)",
                "description":particularText,
                "voucher_no":vocherNumber.text ?? "",
                "branch_id":branch_id,
                "balance":"\(balance)",
                "email":"\(userEmail)",
                "password":pass
            ]
        }
        Toast.showActivity(superView: self.view)
        DataService.shared.uploadTranscation(urlPath: EndPoints.transcation, para: para, image:vocherImage.image) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [unowned self] in
                    Toast.dismissActivity(superView: self.view)
                    Toast.showToast(superView: self.view, message: "Successfully added transcation")
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
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
    }
}
extension UIView{
    func applyCardView(){
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.3
        layer.shadowColor = UIColor.lightText.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.6
    }
}
