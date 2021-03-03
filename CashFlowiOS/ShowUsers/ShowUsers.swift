//
//  ShowUsers.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 25/02/2021.
//

import UIKit
private let cellIdentifer = "cell"
class ShowUsers: UITableViewController {
    lazy private var dataArr = [UsersDataModel]()
    var business_Name = ""
    var branch_Name = ""
    var branch_Id = ""
    var business_Id = ""
    @IBOutlet weak private var businessName:UILabel!{
        didSet{
            businessName.text = business_Name
        }
    }
    @IBOutlet weak private var branchName:UILabel!
    //    @IBOutlet weak private var email:UITextField!
    var isBranch:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ShowUserCell.self, forCellReuseIdentifier: cellIdentifer)
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        customView.backgroundColor = .clear
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add User", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        customView.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        tableView.tableFooterView = customView
        
        
    }
    
    fileprivate func logicallyData() {
        if isBranch != nil
        {
            branchName.isHidden = false
            branchName.text = branch_Name
            fetchAllBuisnessUsers(url: EndPoints.get_branch_users, para: ["id":branch_Id])
            self.navigationItem.title = "\(branch_Name != "" ? branch_Name : business_Name) Users"
        }
        else
        {
            fetchAllBuisnessUsers(url: EndPoints.get_business_users, para: ["id":business_Id])
            self.navigationItem.title = "\(branch_Name != "" ? branch_Name : business_Name) Users"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        logicallyData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! ShowUserCell
        let button = UIButton(type: .custom)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage.init(systemName: "trash.fill"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.addTarget(self, action: #selector(buttonTest(sender:)), for: .touchUpInside)
        button.tag = indexPath.row
        button.sizeToFit()
        cell.accessoryView = button
        cell.dateLabel.text = dataArr[indexPath.item].email
        cell.applyCardView()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func fetchAllBuisnessUsers(url:String,para:[String:String]){
        guard let user = LocalData.getUser(), let _ = user.data.first?.id else {return}
        DataService.shared.getUsers(urlPath: url, para:para)
        { (result) in
            switch result
            {
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.dataArr = model.data
                    self?.tableView.reloadData()
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    print(er)
                }
            }
        }
    }
    
    @objc private func buttonTest(sender:UIButton){
        if isBranch != nil {
            Toast.showActivity(superView: self.view)
            let email = dataArr[sender.tag].email
            DataService.shared.generalApiForAddingStaff(urlPath: EndPoints.delete_user_branch, para: ["email":email,"business_id":self.business_Id,"branch_id":branch_Id]) { (result) in
                switch result
                {
                case .success:
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self!.view)
                        Toast.showToast(superView: self!.view, message: "Deleted")
                        self?.logicallyData()
                    }
                case .failure(let er):
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self!.view)
                        Toast.showToast(superView: self!.view, message: er.localizedDescription)
                    }
                }
            }
            
        }else{
            Toast.showActivity(superView: self.view)
            let email = dataArr[sender.tag].email
            DataService.shared.generalApiForAddingStaff(urlPath: EndPoints.delete_user_business, para: ["email":email,"business_id":self.business_Id]) { (result) in
                switch result
                {
                case .success:
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self!.view)
                        Toast.showToast(superView: self!.view, message: "Deleted")
                        self?.logicallyData()
                    }
                case .failure(let er):
                    DispatchQueue.main.async {
                        [weak self] in
                        Toast.dismissActivity(superView: self!.view)
                        Toast.showToast(superView: self!.view, message: er.localizedDescription)
                    }
                }
            }
            
        }
    }
    //MARK:- Add User
    @objc private func buttonAction()
    {
        if (isBranch != nil){
            // Add to Branch
            let vc = AddUser(nibName: "AddUser", bundle: nil)
            vc.business_Name = business_Name
            vc.business_Id = business_Id
            vc.branch_Name = branch_Name
            vc.branch_Id = branch_Id
            vc.isBranch = true
            vc.completed = {
                [weak self] in
                self?.logicallyData()
            }
            self.present(vc, animated: true, completion: nil)
        }else{
            // Add user to business
            let vc = AddUser(nibName: "AddUser", bundle: nil)
            vc.business_Name = business_Name
            vc.business_Id = business_Id
            //            vc.branch_Name = branch_Name
            //            vc.branch_Id = branch_Id
            vc.completed = {
                [weak self] in
                self?.logicallyData()
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

class ShowUserCell:UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHeaderViews()
    }
    
    let dateLabel: UILabel = {
        let title = UILabel()
        title.text = "INR 234534"
        title.textColor = .black
        title.backgroundColor = .white
        title.font = .systemFont(ofSize: 18, weight: .regular)
        title.minimumScaleFactor = 0.5
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setupHeaderViews()   {
        addSubview(dateLabel)
        
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 10).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

