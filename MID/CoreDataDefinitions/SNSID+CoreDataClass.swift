//
//  SNSID+CoreDataClass.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/11.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


public class SNSID: NSManagedObject {
    // Designed initiater of the superClass of Post
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // Designed initiater of Post
    public init(from newSNSID: CodableSNSID, insertInto context: NSManagedObjectContext) {
        super.init(entity: SNSID.entity(), insertInto: context)
        self.name = newSNSID.name
        self.iDnumber = newSNSID.iDnumber
    }
}
