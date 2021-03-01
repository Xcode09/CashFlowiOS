//
//  LocalDB.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 19/02/2021.
//

import Foundation
struct UserDefaultskeys{
    static let loginUser = "saveuser"
    static let userPassword = "password"
}
struct LocalData{
    static func saveUser(user:Login){
        let encoder = JSONEncoder()
        do{
            let encoded = try encoder.encode(user)
            UserDefaults.standard.set(encoded , forKey: UserDefaultskeys.loginUser)

            UserDefaults.standard.synchronize()
            print("Model Store")
        } catch let error{
            print(error.localizedDescription)
            fatalError()
        }
    }
    static func logoutUser(){
        if let _ = UserDefaults.standard.object(forKey: UserDefaultskeys.loginUser) as? Data {
            UserDefaults.standard.removeObject(forKey: UserDefaultskeys.loginUser)
            UserDefaults.standard.synchronize()
        }
    }
    static func getUser()->Login?{
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaultskeys.loginUser) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(Login.self, from: savedPerson) {
                    return loadedPerson
                }
           }else{
            return nil
        }
        return nil
    }
    
    static func getUserType()->Int?{
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaultskeys.loginUser) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(Login.self, from: savedPerson) {
                    return loadedPerson.data.first?.user_type
                }
           }else{
            return nil
        }
        return nil
    }
    
    static func getUserID()->Int?{
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaultskeys.loginUser) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(Login.self, from: savedPerson) {
                    return loadedPerson.data.first?.user_type == ADMIN ? 0 : loadedPerson.data.first?.id
                }
           }else{
            return nil
        }
        return nil
    }
    
    

    static func saveUserPassword(_ str:String)
    {
        UserDefaults.standard.set(str, forKey: UserDefaultskeys.userPassword)
        UserDefaults.standard.synchronize()
    }
    static func getUserPassword()->String
    {
        if let pass = UserDefaults.standard.value(forKey: UserDefaultskeys.userPassword) as? String
        {
            return pass
        }
        return ""
    }
    static func saveUserSkills(_ str:String)
    {
        UserDefaults.standard.set(str, forKey: "skills")
        UserDefaults.standard.synchronize()
    }
    
    static func setNotificationStatus(_ str:Bool)
    {
        UserDefaults.standard.set(str, forKey: "disableNotifications")
        UserDefaults.standard.synchronize()
    }
    
    static func didClubSendMeNotification(_ str:Bool)
    {
        UserDefaults.standard.set(str, forKey: "setDidClubSendMeNotification")
        UserDefaults.standard.synchronize()
    }
    
    static func getClubSendMeNotification() -> Bool?
    {
        if let status = UserDefaults.standard.value(forKey: "setDidClubSendMeNotification") as? Bool
        {
         
            return status
        }
        return true
    }
    
    static func didFavouritesNotificationReceived(_ str:Bool)
    {
        UserDefaults.standard.set(str, forKey: "didFavouritesNotificationReceived")
        UserDefaults.standard.synchronize()
    }
    
    static func getFavouritesNotificationReceived() -> Bool?
    {
        if let status = UserDefaults.standard.value(forKey: "didFavouritesNotificationReceived") as? Bool
        {
         
            return status
        }
        return true
    }
    
    
    static func setRemainingVideo(_ str:Int)
    {
        UserDefaults.standard.set(str, forKey: "free")
        UserDefaults.standard.synchronize()
    }
    static func getRemainingVideo() -> Int?
    {
        if let videos = UserDefaults.standard.value(forKey: "free") as? Int
        {
            return videos
        }
        return nil
    }
    static func getNotificationStatus() -> Bool?
    {
        if let status = UserDefaults.standard.value(forKey: "disableNotifications") as? Bool
        {
         
            return status
        }
        return true
    }
    
    static func getUserSkills()->String
    {
        if let ski = UserDefaults.standard.value(forKey: "skills") as? String
        {
            return ski
        }
        return ""
    }
    
    
    static func getUserPassword() -> String?
    {
        if let pass = UserDefaults.standard.value(forKey: UserDefaultskeys.userPassword) as? String {
            return pass
        }else{
            return nil
        }
        
    }
    
    static func removeAds(value:Int)
    {
        UserDefaults.standard.set(value, forKey: "removeAds")
        UserDefaults.standard.synchronize()
    }
    static func isRemoveAds()->Bool
    {
        if let _ = UserDefaults.standard.value(forKey: "removeAds") as? Int
        {
            return true
        }
        return false
    }
    
    static func saveMedicalCondition(str:Bool,id:String)
    {
        UserDefaults.standard.setValue([id:str], forKey: "medicalCon")
        UserDefaults.standard.synchronize()
    }
    
    static func saveMedicalShareCondition(str:Bool,id:String)
    {
        UserDefaults.standard.setValue([id:str], forKey: "medicalShare")
        UserDefaults.standard.synchronize()
    }
    
    static func getMedicalCondition(id:String)->Bool?
    {
        if let dic = UserDefaults.standard.value(forKey: "medicalCon") as? [String:Bool]
        {
            if let value = dic[id] , value == true
            {
                return true
            }
            else
            {
                return false
            }
        }
        else{
            return nil
        }
    }
    
    static func getMedicalShare(id:String)->Bool?
    {
        if let dic = UserDefaults.standard.value(forKey: "medicalShare") as? [String:Bool]
        {
            if let value = dic[id] , value == true
            {
                return true
            }
            else
            {
                return false
            }
        }
        else{
            return nil
        }
    }
    
}

