//
//  ViewTranscationVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 25/02/2021.
//

import UIKit

class ViewTranscationVC: UIViewController {

    var transcationId = ""
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
            saleBtn.isEnabled = false
        }
    }
    
    @IBOutlet weak var bottomLabel:UILabel!
    
    @IBOutlet weak var in_outLabel:UILabel!
    @IBOutlet weak var bottomTime:UILabel!
    @IBOutlet weak var topTime:UILabel!
    @IBOutlet weak var topDate:UILabel!
    @IBOutlet weak var receviedBtn:UIButton!{
        didSet{
            receviedBtn.setCardView()
            receviedBtn.isEnabled = false
        }
    }
    @IBOutlet weak var expenseBtn:UIButton!{
        didSet{
            expenseBtn.setCardView()
            receviedBtn.isEnabled = false
        }
    }
    @IBOutlet weak var sentBtn:UIButton!{
        didSet{
            sentBtn.setCardView()
            sentBtn.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDetails()
    }
  
    
   
    
    @objc private func pickImage(){
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.allowsEditing = true
//        pickerController.mediaTypes = ["public.image"]
//        pickerController.sourceType = .photoLibrary
//        self.present(pickerController, animated: true, completion: nil)
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
                    self.updateUID(data: mm)
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

    
    private func updateUID(data:TranscationDataModel)
    {
        balanceView.text = "\(data.balance)"
        particulars.text = data.description
        vocherNumber.text = data.voucher_no
        bottomLabel.text = data.user_email
        bottomTime.text =  TimeAndDateHelper.getServerTime(date: data.created_at)
        topDate.text = TimeAndDateHelper.getServerDate(with: data.created_at)
        topTime.text = TimeAndDateHelper.getServerTime(date: data.created_at)
        if data.category == Expense{
            expenseBtn.backgroundColor = .red
            in_outLabel.text = "OUT"
        }
        else if data.category == Sent{
            sentBtn.backgroundColor = .red
            in_outLabel.text = "OUT"
        }
        else if data.category == Received{
            receviedBtn.backgroundColor = .red
            in_outLabel.text = "IN"
        }else{
            saleBtn.backgroundColor = .red
            in_outLabel.text = "IN"
        }
        do{
            guard let url = URL(string: data.voucher_url ?? "") else {return}
            let dat = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.vocherImage.image = UIImage(data: dat)
            }
        }catch{
            
        }
        
    }
}
