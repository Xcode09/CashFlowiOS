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
            adminPowerBtn.isHidden = true        }
    }
    @IBOutlet weak private var showBranchUsers:UIButton!{
        didSet{
            showBranchUsers.isHidden = true
            
        }
    }
    @IBOutlet weak private var privatereportBtn:UIButton!
    @IBOutlet weak private var balance:UILabel!
    var isAdmin:Bool?
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
        if isAdmin != nil
        {
            adminPowerBtn.isHidden = false
            showBranchUsers.isHidden = false
            longGestureSetup()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = branch_Name
        fetchAllTranscations()
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
    @IBAction private func addTranscation(_ sender:UIButton)
    {
       let vc = TranscationVC(nibName: "TranscationVC", bundle: nil)
        vc.branch_id = branchId
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func longGestureSetup(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc private func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
                return
            }
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)

            if let index = indexPath {
                var _ = self.collectionView.cellForItem(at: index)
                // do stuff with your cell, for example print the indexPath
                showDeleteAlert(indexPath: index.item)
            } else {
                print("Could not find index path")
            }
    }
    
    private func showDeleteAlert(indexPath:Int)
    {
        let alert = UIAlertController(title: "Delete Branch", message: "are you sure to delete \(self.dataArr[indexPath].description)", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let type = LocalData.getUser() , let id = type.data.first?.id else{return}
            let para = ["branch_id":self.branchId,"id":"\(id)","transcation_id":"\(self.dataArr[indexPath].id)"]
            Toast.showActivity(superView: self.view)
            DataService.shared.generalApiForAddingStaff(urlPath: EndPoints.delete_business, para: para) { (result) in
                switch result{
                case .success:
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self?.view ?? UIView())
                        self?.fetchAllTranscations()
                        //self?.collectionView.reloadData()
                    }
                case .failure(let er):
                    print(er)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            /// Call Delete Api
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
extension SignalBranchDetailVC:UIGestureRecognizerDelegate{}
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
        
        let vc = ViewTranscationVC(nibName: "ViewTranscationVC", bundle: nil)
        vc.transcationId =  "\(dataArr[indexPath.item].id)"
        vc.branchId = branchId
        self.present(vc, animated: true, completion: nil)
        
        
//        if let id = LocalData.getUserID(),
//           dataArr[indexPath.item].user_id == "\(id)" || id == ADMIN
//        {
//           // go to edit transcations
//
//            let vc = EditTranscation(nibName: "EditTranscation", bundle: nil)
//            vc.transcationId =  "\(dataArr[indexPath.item].id)"
//            vc.branchId = branchId
//            self.present(vc, animated: true, completion: nil)
//        }
//        else
//        {
//            let vc = ViewTranscationVC(nibName: "ViewTranscationVC", bundle: nil)
//            vc.transcationId =  "\(dataArr[indexPath.item].id)"
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                            String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                        hl, for: indexPath) as! BranchDetailHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 160)
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
    
    @IBAction private func goToReports(_ sender:UIButton)
    {
        let vc = ReportsVC(nibName: "ReportsVC", bundle: nil)
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension UICollectionViewCell{
    func setCardView(){
        layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 8.0
        layer.borderWidth = 0.4
        layer.borderColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        
        
    }
}
