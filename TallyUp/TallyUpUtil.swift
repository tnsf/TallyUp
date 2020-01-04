//
//  TallyUpUtil.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-04.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import Foundation

struct TallyUpUtil {
    static func pluralize(_ count:Int, _ singular:String, withPlural plural:String) -> String {
        return String(format:"%d %@", count, (count == 1 ? singular : plural))
    }

    static func dollarText(ticks:Int) -> String {
        return String(format:"$%0.2f",dollarAmount(ticks:ticks))
    }

    static func dollarAmount(ticks:Int) -> Double {
        return Double(ticks)*0.5
    }   
}