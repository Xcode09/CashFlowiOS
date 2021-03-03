//
//  SignalBusinessBranchVCCollectionViewController.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 17/02/2021.
//

import UIKit

private let reuseIdentifier = "SignalBusinessCellCollectionViewCell"
private let reuseHeaderIdentifier = "HeaderCell"
private let reuseFooterIdentifier = "Footer"

private let reuseEmptyIdentifier = "EmptyCell"

class SignalBusinessBranchVCCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    var business_id : String!
    var business_name : String = ""
    lazy private var dataArr = [BranchDataModel]()
    private var obj : BusinessBranch?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UINib(nibName: reuseHeaderIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        self.collectionView.register(BFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseFooterIdentifier)
        
        self.collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: reuseEmptyIdentifier)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        if let type = LocalData.getUserType() , type == ADMIN{
            longGestureSetup()
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = business_name
        fetchBranchesOfBusiness()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SignalBusinessCellCollectionViewCell
        cell.setCardView()
        cell.branchName.text = dataArr[indexPath.item].name
        cell.balance.text = "\(dataArr[indexPath.item].balance)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SignalBranchDetailVC(nibName: "SignalBranchDetailVC", bundle: nil)
        vc.branchId = "\(dataArr[indexPath.item].id)"
        vc.branch_Name = "\(dataArr[indexPath.item].name)"
        vc.business_Id = dataArr[indexPath.item].business_type_id ?? ""
        if let user = LocalData.getUser(), user.data.first?.user_type == ADMIN {
            vc.isAdmin = true
        }
        vc.business_Name = business_name
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                                    String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                            reuseHeaderIdentifier, for: indexPath) as! HeaderCell
            header.balance.text = "INR \(obj?.total_balance ?? 0)"
            if let us = LocalData.getUser(),us.data.first?.user_type == 0 {
                header.isAdmin = true
            }
            header.busineeName.text = business_name
            header.showBusinessUserTapped = {
                [weak self] in
                let vc = ShowUsers(nibName: "ShowUsers", bundle: nil)
                vc.business_Name = self?.business_name ?? ""
                vc.business_Id = self?.business_id ?? ""
                self?.navigationItem.title = ""
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            header.showReportTapped = {
                [weak self] in
                let vc = ReportsVC(nibName: "ReportsVC", bundle: nil)
                vc.business__id = self?.business_id ?? ""
                self?.navigationItem.title = ""
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            return header
        }else{
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
               reuseFooterIdentifier, for: indexPath) as! BFooter
            //header.backgroundColor = .red
            footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performAction)))
            return footer
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 700, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height:70)
    }
    
    private func fetchBranchesOfBusiness()
    {
        guard let user = LocalData.getUser(), let id = user.data.first?.id else {return}
        self.dataArr.removeAll()
        DataService.shared.fetchBuisnessBranches(urlPath: EndPoints.get_all_branches, para: ["id":"\(id)","business_id":business_id]) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.obj = model
                    self?.dataArr = model.data
                    self?.collectionView.reloadData()
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.collectionView.reloadData()
                }
                
            }
        }
    }
    @objc private func performAction()
    {
        
        let addBusinessVC = BusinessBranchVC(nibName: "BusinessBranchVC", bundle: nil)
        addBusinessVC.business_Id = business_id
        addBusinessVC.business_Name = business_name
        addBusinessVC.completed = {
            [weak self] in
            self?.fetchBranchesOfBusiness()
        }
        self.present(addBusinessVC, animated: true, completion: nil)
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
        let alert = UIAlertController(title: "Delete Branch", message: "are you sure to delete \(self.dataArr[indexPath].name)", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let type = LocalData.getUser() , let id = type.data.first?.id else{return}
            let para = ["business_id":"\(self.business_id ?? "")","branch_id":"\(self.dataArr[indexPath].id)","id":"\(id)"]
            Toast.showActivity(superView: self.view)
            DataService.shared.generalApiForAddingStaff(urlPath: EndPoints.delete_business, para: para) { (result) in
                switch result{
                case .success:
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self?.view ?? UIView())
                        self?.fetchBranchesOfBusiness()
                        //self?.collectionView.reloadData()
                    }
                case .failure(let er):
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self?.view ?? UIView())
                    }
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

extension SignalBusinessBranchVCCollectionViewController:UIGestureRecognizerDelegate{
    
}


class BFooter: UICollectionViewCell  {

override init(frame: CGRect)    {
    super.init(frame: frame)
    setupHeaderViews()
}
    
    var addBusinessTapped:(()->Void)?

private let dateLabel: UIButton = {
    let title = UIButton()
    title.layer.cornerRadius = 8
    title.setTitle("+ ADD BUSINESS BRANCH", for: .normal)
    title.setTitleColor(.white, for: .normal)
    title.backgroundColor = UIColor(named: "AccentColor")
    title.isUserInteractionEnabled = true
    title.addTarget(self, action: #selector(performAction), for: .touchUpInside)
    title.translatesAutoresizingMaskIntoConstraints = false
    return title
}()

func setupHeaderViews()   {
    addSubview(dateLabel)

    dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    dateLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
    dateLabel.heightAnchor.constraint(equalToConstant: 46).isActive = true
}
    
    @objc private func performAction(){
        addBusinessTapped?()
    }


required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}


