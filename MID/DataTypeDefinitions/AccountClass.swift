//
//  AccountClass.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public class Account: DecodableFromFIRReference {
    public let email: String
    public let password: String
    public let name: String
    public var settings: JSONDATA
    public var snsids: JSONDATA?
    public var ref: String {
        let firebaseRoot = Database.rootReference()
        return firebaseRoot.child("userTank").child("\(email)").url
    }
    
    /** Public All-Term init */
    public init(email: String, password: String, name: String, settings: JSONDATA, snsids: JSONDATA?) {
        self.email = email
        self.password = password
        self.name = name
        self.settings = settings
        self.snsids = snsids
    }
    
    
    /** For DecodableFromFIRReference */
    public required convenience init(fromJSON jsonData: JSONDATA) {
        guard let email = jsonData["email"] as? String,
            let password = jsonData["password"] as? String,
            let name = jsonData["name"] as? String,
            let settings = jsonData["settings"] as? JSONDATA,
            let snsids = jsonData["snsids"] as? JSONDATA? else {
                raiseFatalError("Some keys are not matched to the properties of Account.")
                fatalError()
        }
        self.init(email: email, password: password, name: name, settings: settings, snsids: snsids)
    }
}



extension Account: EncodableToFIRReference {
    /** Translate all the elements to JSONDATA for communication. */
    public func toJSON() -> JSONDATA {
        let returnJSON: JSONDATA = [
            "name": self.name,
            "email": self.email,
            "password": self.password,
            "settings": self.settings.expanded(),
            "snsids": self.snsids?.expanded()
        ]
        return returnJSON
    }
}
