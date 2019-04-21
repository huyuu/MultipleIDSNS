////
////  Account+CoreDataClass.swift
////  MID
////
////  Created by 江宇揚 on 2018/12/11.
////  Copyright © 2018 Jiang Yuyang. All rights reserved.
////
////
//
//import Foundation
//import CoreData
//import Firebase
//
//
//public class AccountPast: NSManagedObject, Codable {
//    /** Designed initializer of the superClass */
//    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
//        super.init(entity: entity, insertInto: context)
//    }
//    
//    
//    /** Public all term initializer */
//    public convenience init(name: String, email: String, password: String, snsids: Set<SNSID>? = nil, ref: String, insertInto context: NSManagedObjectContext) {
//        self.init(entity: Account.entity(), insertInto: context)
//        self.name = name
//        self.email = email
//        self.password = password
//        self.ref = ref
//        self.snsids = snsids as NSSet?
//    }
//    
//    
//    /** From JSON data of snapshot */
//    public required convenience init(fromJSON jsonData: JSONDATA, insertInto context: NSManagedObjectContext) {
//        guard let email = jsonData[CodingKeysOfAccount.email.rawValue] as? String,
//            let password = jsonData[CodingKeysOfAccount.password.rawValue] as? String,
//            let name = jsonData[CodingKeysOfAccount.name.rawValue] as? String,
//            let ref = jsonData[CodingKeysOfAccount.ref.rawValue] as? String else {
//                raiseFatalError("Some keys are not matched to the properties of Account.")
//                fatalError()
//        }
//        // Container of snsids
//        var snsidsContainer: Set<SNSID>? = nil
//        // If any snsid exists
//        if let snsids = jsonData[CodingKeysOfAccount.snsids.rawValue] as? JSONDATA {
//            snsidsContainer = Set<SNSID>()
//            for snsid in snsids {
//                if let snsidInfo = snsid.value as? JSONDATA {
//                    snsidsContainer!.insert(SNSID(fromJSON: snsidInfo, insertInto: context))
//                }
//            }
//        }
//        
//        self.init(name: name, email: email, password: password, snsids: snsidsContainer, ref: ref, insertInto: context)
//    }
//    
//    
//    
//    // MARK: - For Codable
//    
//    enum CodingKeysOfAccount: String, CodingKey {
//        typealias RawValue = String
//        case name
//        case email
//        case password
//        case snsids
//        case ref
//    }
//    
//    
//    /** Required init for Decodable */
//    public required convenience init(from decoder: Decoder) throws {
//        // Get coreDataContext from CodingUserInfoKey
//        guard let codingUserInfoKeyCoreDataContext = CodingUserInfoKey.coreDataContext,
//            let context = decoder.userInfo[codingUserInfoKeyCoreDataContext] as? NSManagedObjectContext else {
//                raiseFatalError("Can't get coreDataContext from CodingUserInfoKey")
//                fatalError()
//        }
//        
//        // At this moment, the instance is firstly initiated
//        self.init(entity: Account.entity(), insertInto: context)
//        
//        let container = try decoder.container(keyedBy: CodingKeysOfAccount.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.email = try container.decode(String.self, forKey: .email)
//        self.password = try container.decode(String.self, forKey: .password)
//        self.snsids = try container.decodeIfPresent(Set<SNSID>.self, forKey: .snsids) as NSSet?
//    }
//    
//    
//    /** For Encodable */
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeysOfAccount.self)
//        try container.encode(self.name, forKey: .name)
//        try container.encode(self.email, forKey: .email)
//        try container.encode(self.password, forKey: .password)
//        if let nssetSNSIDs = self.snsids { // At least one SNSID exists
//            // Check if NSSet is convertible to Set<SNSID>
//            guard let setSNSIDs = nssetSNSIDs as? Set<SNSID> else {
//                raiseFatalError("Can't convert NSSet into Set<SNSID> when encoding.")
//                fatalError()
//            }
//            try container.encode(setSNSIDs, forKey: .snsids)
//        }
//    }
//    
//    
//    /** Create JSON data */
//    var toJSON: JSONDATA {
//        var returnJSON: JSONDATA = [
//            CodingKeysOfAccount.name.rawValue: self.name,
//            CodingKeysOfAccount.email.rawValue: self.email,
//            CodingKeysOfAccount.password.rawValue: self.password,
//            CodingKeysOfAccount.ref.rawValue: self.ref
//        ]
//        
//        // If any snsid exists
//        if let snsids = self.snsids {
//            var snsidsJSONContainer: JSONDATA = [:]
//            for snsid in (snsids as! Set<SNSID>) {
//                // Store every reply as [date: JSONDATA]
//                snsidsJSONContainer[snsid.name] = snsid.toJSON
//            }
//            returnJSON[CodingKeysOfAccount.snsids.rawValue] = snsidsJSONContainer
//        }
//        
//        return returnJSON
//    }
//}
//
//
//extension Account: DecodableFromFIRReference {}
