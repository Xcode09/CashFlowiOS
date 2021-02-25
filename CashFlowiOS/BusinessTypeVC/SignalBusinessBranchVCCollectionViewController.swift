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
       
        fetchBranchesOfBusiness()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = business_name
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
        vc.business_Name = business_name
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                                    String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                            reuseHeaderIdentifier, for: indexPath) as! HeaderCell
            header.balance.text = obj?.total_balance ?? "N/A"
            header.busineeName.text = business_name
            header.showBusinessUserTapped = {
                [weak self] in
                let vc = ShowUsers(nibName: "ShowUsers", bundle: nil)
                vc.business_Name = self?.business_name ?? ""
                vc.business_Id = self?.business_id ?? ""
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
                    Toast.showToast(superView: self.view, message: er.localizedDescription)
                }
                
            }
        }
    }
    @objc private func performAction()
    {
        
        let addBusinessVC = BusinessBranchVC(nibName: "BusinessBranchVC", bundle: nil)
        addBusinessVC.business_Id = business_id
        addBusinessVC.business_Name = business_name
        self.present(addBusinessVC, animated: true, completion: nil)
    }
    
}


class BFooter: UICollectionViewCell  {

override init(frame: CGRect)    {
    super.init(frame: frame)
    setupHeaderViews()
}
    
    var addBusinessTapped:(()->Void)?

private let dateLabel: UIButton = {
    let title = UIButton()
    title.setTitle("ADD BUSINESS BRANCH", for: .normal)
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
    dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    dateLabel.heightAnchor.constraint(equalToConstant: 46).isActive = true
}
    
    @objc private func performAction(){
        addBusinessTapped?()
    }


required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}


