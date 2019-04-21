//
//  StoredAccountInfos+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2019/03/15.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension StoredAccountInfos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredAccountInfos> {
        return NSFetchRequest<StoredAccountInfos>(entityName: "StoredAccountInfos")
    }

    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var password: String
    @NSManaged public var ref: String

}
