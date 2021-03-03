//
//  Models.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 19/02/2021.
//

import Foundation
struct Login:Codable{
    let response:String
    let data:[LoginDataModel]
}

struct LoginDataModel:Codable {
    let id: Int
    let name: String
    let user_type: Int
    let email: String
    let business_type:String?
    let business_branch_code: Int?
    let created_at: String
}


struct Businesses:Codable{
    let response:String
    let total_balance:Int
    let data:[BusinessesDataModel]
}

struct BusinessesDataModel:Codable {
    let id: Int
    let name: String
    let user_id: Int?
    let totalBranches:String?
    let balance: Int
    let created_at: String?
}


struct BusinessBranch:Codable{
    let response:String
    let total_balance:Int
    let data:[BranchDataModel]
}

struct BranchDataModel:Codable {
    let id: Int
    let name: String
    let user_id: Int
    let business_type_id:String?
    let balance: Int
    let created_at: String?
}

struct BranchTranscation:Codable{
    let response:String
    let total_balance:Int
    let data:[TranscationDataModel]
}

struct TranscationDataModel:Codable{
    let id: Int
    var description:String
    let category: Int
    let voucher_no:String?
    let is_in_or_out: Bool
    let user_id:String
    let balance: Int
    let total_balance:String
    let voucher_url:String?
    let user_email:String?
    let created_at: String
    
    

}
struct Transcation:Codable{
    let response:String
    let data:[TranscationDataModel]
}



struct ErrorResponse:Codable{
    let response:String
    let message:String
}

struct Reports:Codable{
    let response:String
    let totalBalance:Int
    let data:[ReportData]
    
}
struct ReportData:Codable{
    let balance: Int
    //let created_at: String
}


struct Users:Codable{
    let response:String
    let data:[UsersDataModel]
}

struct UsersDataModel:Codable {
    let id: String
    let name: String
    let email: String
}
