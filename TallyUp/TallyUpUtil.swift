//
//  TallyUpUtil.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-04.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import Foundation
import SwiftUI

struct TallyUpUtil {
    static func pluralize(_ count:Int, _ singular:String, withPlural plural:String) -> String {
        return String(format:"%d %@", count, (count == 1 ? singular : plural))
    }

    static func dollarText(cents:Int16) -> String {
        return String(format:"$%0.2f",Double(cents) / 100.0)
    }

    static func balanceColor(cents:Int16) -> Color {
        return cents < 0 ? .red : .green
    }
}
