//
//  JSONDataForConnection.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/14.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import Foundation
import UIKit

public struct CodablePost: Codable {
    let speakerName: String
    let speakerID: Int64
    let content: String
}
