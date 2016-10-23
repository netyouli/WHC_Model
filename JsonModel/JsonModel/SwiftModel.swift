//
//  SwiftModel.swift
//  JsonModel
//
//  Created by WHC on 16/10/10.
//  Copyright © 2016年 whc. All rights reserved.
//

import Cocoa

@objc enum ENUM_SWIFT: Int {
    case A
    case B
    case C
    case D
}

@objc(SwiftModel)
class SwiftModel: NSObject {
    var policyRuleIndexList: [Int]!
    var em = ENUM_SWIFT.A
}
