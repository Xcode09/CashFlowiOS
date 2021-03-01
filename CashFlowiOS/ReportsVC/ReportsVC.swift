//
//  ReportsVC.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 18/02/2021.
//

import UIKit
import Charts
import DropDown
class ReportsVC: UIViewController{
    
    @IBOutlet weak var businessType:UIButton!
    @IBOutlet weak var branchType:UIButton!
    @IBOutlet weak var inRange:UIButton!
    @IBOutlet weak var inCategory:UIButton!
    @IBOutlet weak var startDateView:UITextField!{
        didSet{
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(startDate(date:)), for: .valueChanged)
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .inline
            } else {
                // Fallback on earlier versions
            }
            startDateView.inputView = datePicker
        }
    }
    @IBOutlet weak var endDateView:UITextField!{
        didSet{
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(endDate(date:)), for: .valueChanged)
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .inline
            } else {
                // Fallback on earlier versions
            }
            endDateView.inputView = datePicker
        }
    }
    @IBOutlet weak var outChart:LineChartView!
    @IBOutlet weak var inChart:LineChartView!
    @IBOutlet weak var customRangeView:UIStackView!
    private lazy var dataArr = [ReportData]()
    private lazy var branchBusiness = [BranchDataModel]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 3.0, 6.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    private var inSelectedRange = ""
    private var inCategoryRange = ""
    var business__id = ""
    var branch__id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reports"
    }
    fileprivate func setupRightBaritem() {
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtn))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    fileprivate func setupUI() {
        businessType.setTitle(globalBusiness.first?.name ?? "Select Business", for: .normal)
        branchType.setTitle(branchBusiness.first?.name ?? "Select Branch", for: .normal)
        inRange.setTitle(dateFilter.first?.replacingOccurrences(of: "_", with: " "), for: .normal)
        inCategory.setTitle(categoryArr.first?.replacingOccurrences(of: "_", with: " "), for: .normal)
        branchType.isEnabled = false
        self.business__id = "\(globalBusiness[0].id)"
        self.branch__id = "\(branchBusiness[0].id)"
        inSelectedRange = THIS_MONTH
        inCategoryRange = "1"
        
        fetchReports(para: ["category":inCategoryRange,"id":branch__id,"dateFilter":inSelectedRange])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDefaultBranchesOfBusiness(business_id: "\(globalBusiness[0].id)")
        self.businessType.setCardView()
        self.inRange.setCardView()
        self.inCategory.setCardView()
        self.branchType.setCardView()
        self.setupRightBaritem()
        
    }


    
    @IBAction private func businessTypeBtn(_ sender:UIButton)
    {
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.anchorView = businessType
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = globalBusiness.map({$0.name})
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.businessType.setTitle(globalBusiness[index].name, for: .normal)
            self.business__id = "\(globalBusiness[index].id)"
            self.fetchBranchesOfBusiness(business_id: "\(globalBusiness[index].id)")
        }
        dropDown.show()
    }
    @IBAction private func branchTypeBtn(_ sender:UIButton)
    {
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.anchorView = branchType
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = branchBusiness.map({$0.name})
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.branch__id = "\(branchBusiness[index].id)"

        }
        dropDown.show()
    }
    @IBAction private func inRangeBtn(_ sender:UIButton)
    {
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.anchorView = inRange
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        let temp = dateFilter.map({$0.replacingOccurrences(of: "_", with: " ")})
        dropDown.dataSource = temp
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if dateFilter[index] == CustomRange {
                customRangeView.isHidden = false
                inSelectedRange = dateFilter[index]
                self.navigationItem.rightBarButtonItem = nil
            }
            else
            {
                customRangeView.isHidden = true
                setupRightBaritem()
                inRange.setTitle(dateFilter[index].replacingOccurrences(of: "_", with: " "), for: .normal)
                inSelectedRange = dateFilter[index]
            }
            
        }
        dropDown.show()
    }
    @IBAction private func inCategoryBtn(_ sender:UIButton)
    {
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.anchorView = inCategory
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        let temp = categoryArr.map({$0.replacingOccurrences(of: "_", with: " ")})
        dropDown.dataSource = temp
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            inCategory.setTitle(categoryArr[index], for: .normal)
            switch categoryArr[index] {
            case "Sale":
                inCategoryRange = "\(Sale)"
            case "Expense":
                inCategoryRange = "\(Expense)"
            case "Received":
                inCategoryRange = "\(Received)"
            case "Sent":
                inCategoryRange = "\(Sent)"
            case "Total_In":
                inCategoryRange = "\(Total_In)"
            case "Total_Out":
                inCategoryRange = "\(Total_Out)"
            default:
                break
            }
        }
        dropDown.show()
    }
    
    
    private func fetchReports(para:[String:String]){
        Toast.showActivity(superView: self.view)
        DataService.shared.fetchReports(urlPath: EndPoints.reports, para: para)
        { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self?.view ?? UIView())
                    self?.dataArr = model.data
                    self?.drawChart(data: model.data)
                    //self?.balance.text = "\(model.total_balance)"
                    //self?.collectionView.reloadData()
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self?.view ?? UIView())
                    Toast.showToast(superView: self?.view ?? UIView(), message: er.localizedDescription)
             }
                
            }
        }
    }
    
    private func drawChart(data:[ReportData] = [ReportData]())
    {
        inChart.delegate = self
        var enteris = [ChartDataEntry]()
        guard dataArr.count > 0 else {
            return
        }
        for i in 0..<data.count{
            enteris.append(ChartDataEntry(x: Double(i), y: Double(data[i].balance)))
        }
        let vc = LineChartDataSet(entries: enteris, label: inCategoryRange)
        let da = LineChartData(dataSet: vc)
        //da.dataSets[0].valueFormatter = self
        inChart.xAxis.labelTextColor = .clear
        inChart.rightAxis.enabled = false
        inChart.rightAxis.drawLabelsEnabled = false
        inChart.leftAxis.drawTopYLabelEntryEnabled = false
        inChart.data = da
    }
    
    @objc private func startDate(date:UIDatePicker){
        startDateView.text = TimeAndDateHelper.getDate(date: date.date)
    }
    @objc private func endDate(date:UIDatePicker){
        endDateView.text = TimeAndDateHelper.getDate(date: date.date)
    }
}

extension ReportsVC:ChartViewDelegate{
    
}

//MARK:- SEARCH WITH CHART
extension ReportsVC{
    @objc fileprivate func searchBtn(){
        if inCategoryRange != "" && inSelectedRange != "" &&
            business__id != "" && branch__id != ""
        {
            fetchReports(para: ["category":inCategoryRange,"id":branch__id,"dateFilter":inSelectedRange])
        }else{
            Toast.showToast(superView: self.view, message: "Please select all fields")
        }
    }
}


extension ReportsVC{
    private func fetchBranchesOfBusiness(business_id:String)
    {
        guard let user = LocalData.getUser(), let id = user.data.first?.id else {return}
        DataService.shared.fetchBuisnessBranches(urlPath: EndPoints.get_all_branches, para: ["id":"\(id)","business_id":business_id]) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.branchBusiness = model.data
                    self?.branchType.isEnabled = true
                    self?.branchType.setTitle(self?.branchBusiness.first?.name ?? "", for: .normal)
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    Toast.showToast(superView: self.view, message: er.localizedDescription)
                }
            }
        }
    }
    
    private func fetchDefaultBranchesOfBusiness(business_id:String)
    {
        guard let user = LocalData.getUser(), let id = user.data.first?.id else {return}
        Toast.showActivity(superView: self.view)
        DataService.shared.fetchBuisnessBranches(urlPath: EndPoints.get_all_branches, para: ["id":"\(id)","business_id":business_id]) { (result) in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self?.view ?? UIView())
                    self?.branchBusiness = model.data
                    self?.branchType.isEnabled = true
                    self?.branchType.setTitle(self?.branchBusiness.first?.name ?? "", for: .normal)
                    self?.setupUI()
                    
                }
            case .failure(let er):
                DispatchQueue.main.async {
                    [weak self] in
                    Toast.dismissActivity(superView: self?.view ?? UIView())
                    Toast.showToast(superView: self?.view ?? UIView(), message: er.localizedDescription)
                }
            }
        }
    }
}


class ChartStringFormatter: NSObject, IAxisValueFormatter {

    var nameValues: [String]! =  ["A", "B", "C", "D"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
}
