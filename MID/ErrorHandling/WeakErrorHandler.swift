//
//  WeakErrorHandler.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/11.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit


public func raiseWeakError(_ message: String) {
    sendMessageToControlCenter(message)
    print("A weak error has occured:\n" + message)
}

public func raiseFatalError(_ message: String) {
    sendMessageToControlCenter(message)
    print("A fatal error has occured:\n" + message)
    // Todo: something appear in UI
}

func sendMessageToControlCenter(_ message: String) {
    
}
