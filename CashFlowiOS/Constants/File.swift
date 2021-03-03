//
//  File.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 17/02/2021.
//

import UIKit


let Expense = 3
let Sent = 4
let Sale = 1
let Received = 2
let Total_In = 6
let Total_Out = 7
let IN = true
let OUT = false
let LAST_MONTH = "LAST_MONTH"
let LAST_YEAR = "LAST_YEAR"
let LAST_WEEK = "LAST_WEEK"
let THIS_YEAR = "THIS_YEAR"
let THIS_MONTH = "THIS_MONTH"
let Thirty_Days = "30Days"
let THIS_FY = "THIS_FY"
let LAST_FY = "LAST_FY"
let CustomRange = "Custom Range"
let ADMIN = 0

let SERVER_DATE_FORMATE = "yyyy-MM-dd HH:mm:ss"

let dateFilter = [THIS_MONTH,LAST_YEAR,"Last 30 Days",THIS_YEAR,LAST_YEAR, THIS_FY , LAST_FY, CustomRange]

let categoryArr = ["Total_Out","Expense","Sent","Total_In","Sale","Received"]


enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
    case createUser
}
extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .createUser:
            return "Create User"
        case .custom(let message):
            return message
        }
    }
}
extension ServiceError {
    init(json: [String:Any]) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}

struct EndPoints {
    private let baseURL = "https://cashflow.genetum.com/api/"
    static let business = "\(EndPoints.init().baseURL)business"
    static let all_business = "\(EndPoints.init().baseURL)all_business"
    static let add_branch = "\(EndPoints.init().baseURL)add_branch"
    static let get_all_branches = "\(EndPoints.init().baseURL)get_all_branches"
    static let get_specific_business_branches = "\(EndPoints.init().baseURL)get_specific_business_branches"
    
    static let edit_transcation = "\(EndPoints.init().baseURL)edit_transcation"
    static let get_sepcific_transaction = "\(EndPoints.init().baseURL)get_sepcific_transaction"
    static let register = "\(EndPoints.init().baseURL)register"
    static let login = "\(EndPoints.init().baseURL)login"
    static let transcation = "\(EndPoints.init().baseURL)transcation"
    static let reports = "\(EndPoints.init().baseURL)reports"
    static let transcation_of_branch = "\(EndPoints.init().baseURL)transcation_of_branch"
    
    static let get_business_users = "\(EndPoints.init().baseURL)get_business_users"
    
    static let get_branch_users = "\(EndPoints.init().baseURL)get_branch_users"
    static let add_user_branch = "\(EndPoints.init().baseURL)add_user_branch"
    static let add_user_business = "\(EndPoints.init().baseURL)add_user_business"
    
    
    static let delete_transcation = "\(EndPoints.init().baseURL)delete_transcation"
    static let delete_business = "\(EndPoints.init().baseURL)delete_business"
    
    static let delete_branch = "\(EndPoints.init().baseURL)delete_branch"
    
    static let delete_user_business = "\(EndPoints.init().baseURL)delete_user_business"
    static let delete_user_branch = "\(EndPoints.init().baseURL)delete_user_business"
    
}


struct TimeAndDateHelper {
    static func getTime()->String{
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none

        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
    }
    
    static func getDate(date:Date=Date())->String{
        let currentDateTime = date
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
    }
    
    static func getServerDate(with date:String)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = SERVER_DATE_FORMATE
        guard let serverDate = dateFormatter.date(from: date)
        else{return date}
        //let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.timeStyle = .none
        formatter.dateStyle = .medium

        // get the date time String from the date object
        return formatter.string(from: serverDate)
    }
    
    static func getServerTime(date:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = SERVER_DATE_FORMATE
        guard let serverDate = dateFormatter.date(from: date)
        else{return date}
        //let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.timeStyle = .short
        formatter.dateStyle = .none

        // get the date time String from the date object
        return formatter.string(from: serverDate)
    }
}
public func checkTranscationCategory(category:Int,foregroundColor:CGColor=UIColor.black.cgColor)->(Bool,NSAttributedString)
{
    if Expense == category
    {
        return (OUT,makeAttributeString(myString: "Expense", foregroundColor: foregroundColor))
    }else if Sent == category
    {
        return (OUT,makeAttributeString(myString: "Sent", foregroundColor:foregroundColor))
    }
    else if Received == category
    {
        
        return (IN,makeAttributeString(myString: "Received", foregroundColor:foregroundColor))
    }else
    {
        return (IN,makeAttributeString(myString: "Sale", foregroundColor:foregroundColor))
    }
}
public func makeAttributeString(myString:String,foregroundColor:CGColor)->NSAttributedString{
    //let myString = "Swift Attributed String"
    let myAttribute = [ NSAttributedString.Key.foregroundColor: foregroundColor]
    let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)

    // set attributed text on a UILabel
    return myAttrString
}
