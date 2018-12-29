//
//  Account+CoreDataClass.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/11.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData
import Firebase


public class Account: NSManagedObject, Codable {
    /** Designed initializer of the superClass */
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    /** Public all term initializer */
    public convenience init(name: String, email: String, password: String, insertInto context: NSManagedObjectContext) {
        self.init(entity: Account.entity(), insertInto: context)
        self.name = name
        self.email = email
        self.password = password
        self.iDnumber = Int64(email.hashValue)
        self.snsids = nil
    }
    
    
    /** From JSON data of snapshot */
    public convenience init(fromJSON jsonData: [String: Any], insertInto context: NSManagedObjectContext) {
        guard let email = jsonData["email"] as? String,
            let password = jsonData["password"] as? String,
            let name = jsonData["name"] as? String else {
                raiseFatalError("Some keys are not matched to the properties of Account.")
                fatalError()
        }
        self.init(name: name, email: email, password: password, insertInto: context)
        // Check if there are snsids
        if let snsids = jsonData["snsids"] as? [String: Any] {
            for snsid in snsids {
                let newSNSID = SNSID(fromJSON: [snsid.key: snsid.value], owner: self, insertInto: context)
                self.addToSnsids(newSNSID)
            }
        }
    }
    
    
    
    // MARK: - For Codable
    
    enum CodingKeysOfAccount: String, CodingKey {
        typealias RawValue = String
        case name
        case email
        case password
        case snsids
    }
    
    
    /** Required init for Decodable */
    public required convenience init(from decoder: Decoder) throws {
        // Get coreDataContext from CodingUserInfoKey
        guard let codingUserInfoKeyCoreDataContext = CodingUserInfoKey.coreDataContext,
            let context = decoder.userInfo[codingUserInfoKeyCoreDataContext] as? NSManagedObjectContext else {
                raiseFatalError("Can't get coreDataContext from CodingUserInfoKey")
                fatalError()
        }
        
        // At this moment, the instance is firstly initiated
        self.init(entity: Account.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeysOfAccount.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.iDnumber = Int64(self.email.hashValue)
        self.snsids = try container.decodeIfPresent(Set<SNSID>.self, forKey: .snsids) as NSSet?
    }
    
    
    /** For Encodable */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysOfAccount.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.password, forKey: .password)
        if let nssetSNSIDs = self.snsids { // At least one SNSID exists
            // Check if NSSet is convertible to Set<SNSID>
            guard let setSNSIDs = nssetSNSIDs as? Set<SNSID> else {
                raiseFatalError("Can't convert NSSet into Set<SNSID> when encoding.")
                fatalError()
            }
            try container.encode(setSNSIDs, forKey: .snsids)
        }
    }
    
    
    /** Create JSON data */
//    var toJSON: Dictionary<String, Any> {
//        if let snsids = self.snsids {
//            return [
//                "name": self.name,
//                "email": self.email,
//                "password": self.password,
//                "snsids": (snsids.allObjects as! [SNSID]).map{ $0.toJSON }
//            ]
//        } else {
//            return [
//                "name": self.name,
//                "email": self.email,
//                "password": self.password,
//            ]
//        }
//    }
    
    var toJSON: Dictionary<String, Any> {
        return [
            "name": self.name,
            "email": self.email,
            "password": self.password
        ]
    }
}


