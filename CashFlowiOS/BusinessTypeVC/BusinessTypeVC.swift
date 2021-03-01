//
//  BusinessTypeVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 17/02/2021.
//

import UIKit

private let reuseIdentifier = "BusinessTypeCell"

private let reuseHeaderIdentifier = "Header"
private let reuseFooterIdentifier = "Footer"

private let reuseEmptyIdentifier = "EmptyCell"
var globalBusiness = [BusinessesDataModel]()
class BusinessTypeVC: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    private lazy var dataArr = [BusinessesDataModel]()
    private var businessD : Businesses?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        self.collectionView.register(Footer.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseFooterIdentifier)
        
        self.collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: reuseEmptyIdentifier)
        
        
        // Do any additional setup after loading the view.
        
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Cash Flow"
        fetchAllUserBuisness()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BusinessTypeCell
        cell.setCardView()
        cell.model = dataArr[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SignalBusinessBranchVCCollectionViewController(nibName: "SignalBusinessBranchVCCollectionViewController", bundle: nil)
        vc.business_id = "\(self.dataArr[indexPath.item].id)"
        vc.business_name = "\(self.dataArr[indexPath.item].name)"
        if let us = LocalData.getUser(),us.data.first?.user_type == 0 {
            //vc.isAdmin = true
        }
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
               reuseHeaderIdentifier, for: indexPath) as! Header
            header.dateLabel.text = "INR \(businessD?.total_balance ?? 0)"
            return header
        }else if kind == UICollectionView.elementKindSectionFooter,let id = LocalData.getUserType(),id == ADMIN
        {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
               reuseFooterIdentifier, for: indexPath) as! Footer
            //header.backgroundColor = .red
            footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performAction)))
            
//            footer.addBusinessTapped = {
//                [weak self] in
//                let addBusinessVC = AddBusinessVC(nibName: "AddBusinessVC", bundle: nil)
//                self?.present(addBusinessVC, animated: true, completion: nil)
//            }
            return footer
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseEmptyIdentifier, for: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }

        //--------------------------------------------------------------------------------

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }

        //--------------------------------------------------------------------------------

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = UIScreen.main.bounds.size

            // 8 - space between 3 collection cells
            // 4 - 4 times gap will appear between cell.
                    return CGSize(width: (size.width - 4 * 8)/3, height: 180)
//            return CGSize(width: (self.collectionView.frame.width/3.0) - 8 , height: (self.collectionView.frame.height/4.7))
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 600, height: 70)
    }

        //--------------------------------------------------------------------------------

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
        }
    
    @objc private func performAction(){
        let addBusinessVC = AddBusinessVC(nibName: "AddBusinessVC", bundle: nil)
        self.present(addBusinessVC, animated: true, completion: nil)
    }
    
    private func fetchAllUserBuisness(){
        guard let user = LocalData.getUser(), let id = user.data.first?.id else {return}
        self.dataArr.removeAll()
        DataService.shared.fetchAllUserBuisness(urlPath: EndPoints.all_business, para: ["id":"\(id)"]) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.businessD = model
                    self?.dataArr = model.data
                    globalBusiness = model.data
                    self?.collectionView.reloadData()
                }
            case .failure(let er):
                print(er)
            }
        }
    }
    
    
    
    
}
class Header: UICollectionViewCell  {

override init(frame: CGRect)    {
    super.init(frame: frame)
    setupHeaderViews()
}

let dateLabel: UILabel = {
    let title = UILabel()
    title.text = "INR 234534"
    title.textColor = .black
    title.backgroundColor = .white
    title.font = .systemFont(ofSize: 20, weight: .bold)
    title.translatesAutoresizingMaskIntoConstraints = false
    return title
}()

func setupHeaderViews()   {
    addSubview(dateLabel)

    dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    dateLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
}


required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
class Footer: UICollectionViewCell  {

override init(frame: CGRect)    {
    super.init(frame: frame)
    setupHeaderViews()
}
    
    var addBusinessTapped:(()->Void)?

private let dateLabel: UIButton = {
    let title = UIButton()
    title.setTitle("ADD BUSINESS", for: .normal)
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


class EmptyCell: UICollectionViewCell  {

override init(frame: CGRect)    {
    super.init(frame: frame)
    //setupHeaderViews()
}

//let dateLabel: UILabel = {
//    let title = UILabel()
//    title.text = "INR 234534"
//    title.textColor = .black
//    title.backgroundColor = .white
//    title.font = .systemFont(ofSize: 20, weight: .bold)
//    title.translatesAutoresizingMaskIntoConstraints = false
//    return title
//}()
//
//func setupHeaderViews()   {
//    addSubview(dateLabel)
//
//    dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//    dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
//    dateLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
//    dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//}


required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
