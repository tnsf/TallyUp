//
//  UserData.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-23.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import Foundation

final class UserData : ObservableObject {
    @Published var totalTicks = 0
    @Published var currentSessionTickIncrement = 0
    
    func increment(_ numTicks:Int = 1) {
        self.currentSessionTickIncrement += numTicks
    }
    func decrement(_ numTicks:Int = 1) {
        let finalNumTicks = currentSessionTickIncrement-numTicks
        if (finalNumTicks > 0)
        {
            currentSessionTickIncrement = finalNumTicks
        }
        else
        {
            currentSessionTickIncrement = 0
        }
    }
    func apply()
    {
        totalTicks += currentSessionTickIncrement
        clear()
    }
    func clear()
    {
        currentSessionTickIncrement = 0
    }
}
