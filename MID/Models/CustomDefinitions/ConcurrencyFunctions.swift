//
//  ConcurrencyFunctions.swift
//  MID
//
//  Created by 江宇揚 on 2019/01/01.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public func asyncFunction(of function: @escaping (Any) -> Any, with parameters: Any,
                          runQueue: DispatchQueue=DispatchQueue.global(),
                          group: DispatchGroup=DispatchGroup(),
                          completionQueue: DispatchQueue=DispatchQueue.global(),
                          completeWith completionParameters: Any?=nil,
                          completionHandler: @escaping (Any?, Any, Error?) -> Void) {
    group.enter()
    runQueue.async {
        let error: Error? = nil
        let result = function(parameters)
        completionQueue.async {
            completionHandler(completionParameters, result, error)
            group.leave()
        }
    }
}

