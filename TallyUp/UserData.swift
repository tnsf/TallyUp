//
//  UserData.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-23.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import Foundation

enum TransactionType
{
    case charge
    case credit
}

struct Transaction
{
    var date : Date
    var type : TransactionType
    var amount : Int
}

final class UserData : ObservableObject {
    @Published var totalTicks = 0
    @Published var currentSessionTickIncrement = 0
    @Published var transactions : [Transaction] = [Transaction]()
    
    init(balance:Int = 0,currentTicks:Int = 0)
    {
        totalTicks = balance
        currentSessionTickIncrement = currentTicks
    }
    
    // Computations
    func dollarText(ticks:Int) -> String {
        return String(format:"$%0.2f",dollarAmount(ticks:ticks))
    }
    func dollarAmount(ticks:Int) -> Double {
        return Double(ticks)*0.5
    }

    // Actions
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
    func clear()
    {
        currentSessionTickIncrement = 0
    }
    func charge()
    {
        if currentSessionTickIncrement > 0
        {
            totalTicks -= currentSessionTickIncrement
            transactions.append(Transaction(date:Date(),type:.charge,amount:currentSessionTickIncrement))
        }
        clear()
    }
    func credit(ticks:Int) {
        // if currentSessionTicksIncrement != 0 { error }
        totalTicks += ticks
        transactions.append(Transaction(date:Date(),type:.credit,amount:currentSessionTickIncrement))
    }
    func credit(dollars:Double) {
        credit(ticks:Int(dollars*2.0+0.5))
    }
}
