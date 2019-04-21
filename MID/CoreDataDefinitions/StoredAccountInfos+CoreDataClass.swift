//
//  StoredAccountInfos+CoreDataClass.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData
import Firebase


public class StoredAccountInfos: NSManagedObject {
    /** Designed initializer of the superClass */
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    /** Public all term initializer */
    public convenience init(email: String, name: String, password: String, insertInto context: NSManagedObjectContext) {
        self.init(entity: StoredAccountInfos.entity(), insertInto: context)
        self.name = name
        self.email = email
        self.password = password
        var ref: String {
            return Database.rootReference().child("userTank/\(email)").url
        }
        self.ref = ref
    }
}
