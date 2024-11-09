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

    static func dollarText(ticks:Int16) -> String {
        return String(format:"$%0.2f",dollarAmount(ticks:ticks))
    }

    static func dollarAmount(ticks:Int16) -> Double {
        return Double(ticks)/Double(ticksPerDollar())
    }
    
    static func balanceColor(ticks:Int16) -> Color {
        return ticks < 0 ? .red : .green
    }

    static func ticksPerDollar() -> Int16 {
        return 2
    }
}
