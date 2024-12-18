//
//  EditTranscation.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 25/02/2021.
//

import UIKit

class EditTranscation: UIViewController {

    private var selectCategory : Int?
    var transcationId = ""
    var branchId = ""
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
    @IBOutlet weak var in_outLabel:UILabel!
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
        
        getDetails()
    }
    @IBAction private func categoryExpense(_ sender:UIButton)
    {
        selectCategory = sender.tag
        expenseBtn.setState()
        saleBtn.setCardView()
        sentBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categorySale(_ sender:UIButton)
    {
        selectCategory = sender.tag
        saleBtn.setState(color: .white, backClr: UIColor(named: "INCLR")!)
        expenseBtn.setCardView()
        sentBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categorySent(_ sender:UIButton)
    {
        selectCategory = sender.tag
        sentBtn.setState()
        saleBtn.setCardView()
        expenseBtn.setCardView()
        receviedBtn.setCardView()
    }
    @IBAction private func categoryReceved(_ sender:UIButton)
    {
        selectCategory = sender.tag
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
        guard
              let particularText = particulars.text,
              let category = selectCategory,
              let balance = balanceView.text,
              let user = LocalData.getUser(),
              let userEmail = user.data.first?.email,
              let pass = LocalData.getUserPassword()
        else {
            return Toast.showToast(superView: self.view, message: "Please fill all fields")
        }
        if vocherNumber.text == nil{
            
        }
        var para = [String:String]()
        if vocherNumber.text == nil
        {
            para = [
                "category":"\(category)",
                "description":particularText,
                "branch_id":branchId,
                "balance":"\(balance)",
                "email":"\(userEmail)",
                "password":pass,
                "transcation_id":transcationId
            ]
        }
        else
        {
            para = [
                "category":"\(category)",
                "description":particularText,
                "voucher_no":vocherNumber.text ?? "",
                "branch_id":branchId,
                "balance":"\(balance)",
                "email":"\(userEmail)",
                "password":pass,
                "transcation_id":transcationId
            ]
        }
        Toast.showActivity(superView: self.view)
        DataService.shared.uploadTranscation(urlPath: EndPoints.edit_transcation, para: para, image:vocherImage.image) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [unowned self] in
                    Toast.dismissActivity(superView: self.view)
                    Toast.showToast(superView: self.view, message: model)
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
    private func updateUI(data:TranscationDataModel)
    {
        selectCategory = data.category
        balanceView.text = "\(data.balance)"
        particulars.text = data.description
        vocherNumber.text = data.voucher_no
        bottomLabel.text = data.user_email
        bottomTime.text =  TimeAndDateHelper.getServerTime(date: data.created_at)
        topDate.text = TimeAndDateHelper.getServerDate(with: data.created_at)
        topTime.text = TimeAndDateHelper.getServerTime(date: data.created_at)
        if data.category == Expense{
            expenseBtn.setState()
            in_outLabel.text = "OUT"
        }
        else if data.category == Sent{
            sentBtn.setState()
            in_outLabel.text = "OUT"
        }
        else if data.category == Received{
            receviedBtn.setState(color: .white, backClr: UIColor(named: "INCLR")!)
            in_outLabel.text = "IN"
        }else{
            saleBtn.setState(color: .white, backClr: UIColor(named: "INCLR")!)
            in_outLabel.text = "IN"
        }
        do{
            guard let url = URL(string: data.voucher_url ?? "") else{return}
            let dat = try Data(contentsOf:url)
            DispatchQueue.main.async {
                self.vocherImage.image = UIImage(data: dat)
            }
        }
        catch
        {
            
        }
        
    }
    
    private func getDetails(){
         
         Toast.showActivity(superView: self.view)
         
         DataService.shared.fetchSignalTranscations(urlPath: EndPoints.get_sepcific_transaction, para: ["transaction_id":transcationId]) { (result) in
             switch result{
             case .success(let model):
                 DispatchQueue.main.async {
                     [unowned self] in
                     Toast.dismissActivity(superView: self.view)
                     guard let mm = model.data.first else{return}
                     self.updateUI(data: mm)
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

extension EditTranscation: UIImagePickerControllerDelegate,UINavigationControllerDelegate{

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
    func setState(color:UIColor = .white,backClr:UIColor = .red)
    {
        backgroundColor = backClr
        setTitleColor(color, for: .normal)
    }
}
