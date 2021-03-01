//
//  DataService.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 17/02/2021.
//

import Foundation
import Alamofire
typealias Parameters = [String: String]
final class DataService{
    static let shared = DataService()
    private init(){}
    
    func getAppStatus(urlPath: String,compilationHandler:@escaping (Result<Any?>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        
        let param = ["q":"boise","appid":"apiKey"]
        for (key,value) in param {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    let _ = json?["message"] as! String
                    compilationHandler(.success(json))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }

    
    func login(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<Any?>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(Login.self, from: data)
                    LocalData.saveUser(user: user)
                    LocalData.saveUserPassword(para["password"]!)
                    print(user.data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    
    
    func fetchAllUserBuisness(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<Businesses>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(Businesses.self, from: data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    
    
    func fetchAllUserBuisnessBranches(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<[BusinessesDataModel]>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
               
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(Businesses.self, from: data)
                    compilationHandler(.success(user.data))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    
    func fetchBuisnessBranches(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<BusinessBranch>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
               
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(BusinessBranch.self, from: data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    func uploadTranscation(urlPath: String,para:[String:String],image:UIImage?,compilationHandler:@escaping (Result<String>) -> Void)
    {
        // ActivityController.init().showIndicator()
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        Alamofire.upload(multipartFormData: { (mutlipart) in
            if image != nil {
                guard let imageData = image?.jpegData(compressionQuality: 0.5) else {return}
                mutlipart.append(imageData, withName: "file", fileName: "voucher\(Date().timeIntervalSince1970)", mimeType: "image/jpg")
            }
            for (key, value) in para {
                if let data = value.data(using: .utf8) {
                    mutlipart.append(data, withName: key)
                }
            }
        }, to: urlPath,method: .post,headers: nil) { (result) in
           
            switch result {
            case .success(let upload, _, _):
                upload.validate().responseJSON { (resultData) in
                    
                    switch resultData.result{
                    case .success :
                        guard let mydata = resultData.data else{
                            return
                            
                        }
                        if let json = try? JSONSerialization.jsonObject(with: mydata, options: .mutableContainers) as? [String:Any]{
                            let message = json["response"] as! String
                            compilationHandler(.success(message))
                        }
                        else{
                            compilationHandler(.failure(ServiceError.other))
                        }
                        
                        
                    case .failure(let error):
                        if resultData.response?.statusCode == 422
                        {
                            compilationHandler(.failure(ServiceError.other))
                        }
                        else
                        {
                           compilationHandler(.failure(error))
                        }
                    }
                }
            case .failure(let encodingError):
                compilationHandler(.failure(encodingError))
                print("multipart upload encodingError: \(encodingError)")
            }
        }
    }
    
    func getUsers(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<Users>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(Users.self, from: data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    
    
    func fetchBranchTranscations(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<BranchTranscation>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
               
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(BranchTranscation.self, from: data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    func fetchSignalTranscations(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<Transcation>) -> Void)
    {
        // ActivityController.init().showIndicator()
        
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
               
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(Transcation.self, from: data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    func fetchReports(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<Reports>) -> Void)
    {
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
               
                guard let data = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                do{
                    let user = try JSONDecoder.init().decode(Reports.self, from: data)
                    compilationHandler(.success(user))
                }
                catch let er {
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
        }.resume()
    }
    
    
    
    private func generateBoundary() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
        
    fileprivate func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
            
            let lineBreak = "\r\n"
            var body = Data()
            
            if let parameters = params {
                for (key, value) in parameters {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                    body.append("\(value + lineBreak)")
                }
            }
            
            if let media = media {
                for photo in media {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                    body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                    body.append(photo.data)
                    body.append(lineBreak)
                }
            }
            
            body.append("--\(boundary)--\(lineBreak)")
            
            return body
        }
    
    
    func generalApiForAddingStaff(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<String>) -> Void)
    {
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                
                compilationHandler(.failure(ServiceError.other))
            }
            else
            {
                guard let _ = Data else {
                    return compilationHandler(.failure(ServiceError.other))
                }
                compilationHandler(.success("Successfully Saved"))
            }
        }.resume()
    }
    
    func addingStaff(urlPath: String,para:[String:String],compilationHandler:@escaping (Result<String>) -> Void)
    {
        guard var myURL = URLComponents(string: urlPath) else {
            return compilationHandler(.failure(ServiceError.custom("Invalid URL")))
        }
        var items = [URLQueryItem]()
        for (key,value) in para {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL.queryItems = items
        
        guard let url = myURL.url else {
            return compilationHandler(.failure(ServiceError.custom("No URL")))}
        
        var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (Data, response, error) in
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode != 200
            {
                if httpRes.statusCode == 404{
                    compilationHandler(.failure(ServiceError.createUser))
                    return
                }
                do{
                    guard let data = Data else {
                        return compilationHandler(.failure(ServiceError.other))
                    }
                    let err = try JSONDecoder.init().decode(ErrorResponse.self, from:data)
                    compilationHandler(.failure(ServiceError.custom(err.message)))
                }
                catch let er{
                    compilationHandler(.failure(ServiceError.custom(er.localizedDescription)))
                }
            }
            else
            {
                
                compilationHandler(.success("Successfully Saved"))
            }
        }.resume()
    }
    
}

import UIKit
fileprivate struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String)
    {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "Vocherimage.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
