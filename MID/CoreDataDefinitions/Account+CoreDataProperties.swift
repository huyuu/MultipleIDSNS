//
//  Account+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/31.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var password: String
    @NSManaged public var ref: String
    @NSManaged public var snsids: NSSet?

}

// MARK: Generated accessors for snsids
extension Account {

    @objc(addSnsidsObject:)
    @NSManaged public func addToSnsids(_ value: SNSID)

    @objc(removeSnsidsObject:)
    @NSManaged public func removeFromSnsids(_ value: SNSID)

    @objc(addSnsids:)
    @NSManaged public func addToSnsids(_ values: NSSet)

    @objc(removeSnsids:)
    @NSManaged public func removeFromSnsids(_ values: NSSet)

}
