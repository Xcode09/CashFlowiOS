//
//  SignalBranchDetailVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 18/02/2021.
//

import UIKit

class SignalBranchDetailVC: UIViewController {
    
    private let cl = "BranchDetailVC"
    private let hl = "BranchDetailHeader"
    @IBOutlet weak private var busineeName:UILabel!
    @IBOutlet weak private var branchName:UILabel!
    @IBOutlet weak private var adminPowerBtn:UIButton!{
        didSet{
            adminPowerBtn.isHidden = false        }
    }
    @IBOutlet weak private var privatereportBtn:UIButton!
    @IBOutlet weak private var balance:UILabel!
    var isAdmin:Bool?{
        didSet{
            adminPowerBtn.isHidden = false
        }
    }
    @IBOutlet weak private var collectionView:UICollectionView!
    {
        didSet
        {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: cl, bundle: nil), forCellWithReuseIdentifier: cl)
            collectionView.register(UINib(nibName: hl, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: hl)
        }
    }
    var business_Name = ""
    var business_Id = ""
    var branchId = ""
    var branch_Name = ""
    lazy private var dataArr = [TranscationDataModel]()
    private var obj : BranchTranscation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.branchName.text = branch_Name
        self.busineeName.text = business_Name
        // Do any additional setup after loading the view.
        
        fetchAllTranscations()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = branch_Name
    }
    @IBAction private func showBusinessUsers(_ sender:UIButton){
        let vc = ShowUsers(nibName: "ShowUsers", bundle: nil)
        vc.business_Name = business_Name
        vc.business_Id = business_Id
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func showBranchUsers(_ sender:UIButton){
        let vc = ShowUsers(nibName: "ShowUsers", bundle: nil)
        vc.business_Name = business_Name
        vc.business_Id = business_Id
        vc.branch_Id = branchId
        vc.branch_Name = branch_Name
        vc.isBranch = true
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
extension SignalBranchDetailVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cl, for: indexPath) as! BranchDetailVC
        cell.setCardView()
        cell.tr = dataArr[indexPath.item]
        //cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = LocalData.getUserID(),
           dataArr[indexPath.item].user_id == "\(id)" || id == ADMIN
        {
           // go to edit transcations
            
            let vc = EditTranscation(nibName: "EditTranscation", bundle: nil)
            vc.transcationId =  "\(dataArr[indexPath.item].id)"
            vc.branchId = branchId
            self.present(vc, animated: true, completion: nil)
        }
        else
        {
            let vc = ViewTranscationVC(nibName: "ViewTranscationVC", bundle: nil)
            vc.transcationId =  "\(dataArr[indexPath.item].id)"
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                            String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                        hl, for: indexPath) as! BranchDetailHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 5, height: 160)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        .init(width: collectionView.frame.width, height: 60)
    //    }
    private func fetchAllTranscations(){
        guard let user = LocalData.getUser(), let _ = user.data.first?.id else {return}
        DataService.shared.fetchBranchTranscations(urlPath: EndPoints.transcation_of_branch, para: ["branch_id":branchId]) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.dataArr = model.data
                    self?.balance.text = "\(model.total_balance)"
                    self?.collectionView.reloadData()
                }
            case .failure(let er):
                print(er)
            }
        }
    }
    
}


extension UICollectionViewCell{
    func setCardView(){
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.7
    }
}
