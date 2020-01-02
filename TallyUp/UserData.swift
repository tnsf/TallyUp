//
//  UserData.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-23.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import Foundation

struct Transaction : Identifiable, Comparable
{
    var id: UUID

    var date : Date
    var type : TransactionType
    var amount : Int
    
    enum TransactionType : String
    {
        var description: String
        {
            return self.rawValue
        }
        
        case Charge
        case Credit
    }

    init(date:Date = Date(), type:TransactionType = .Charge, amount:Int = 0)
    {
        self.id = UUID()
        self.date = date
        self.type = type
        self.amount = amount
    }

    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date < rhs.date
    }
}

final class UserData : ObservableObject {
    @Published var totalTicks = 0
    @Published var transactions : [Transaction] = [Transaction]()
    
    init(balance:Int = 0,currentTicks:Int = 0)
    {
        totalTicks = balance
    }
    
    // Computations
    static func dollarText(ticks:Int) -> String {
        return String(format:"$%0.2f",dollarAmount(ticks:ticks))
    }
    static func dollarAmount(ticks:Int) -> Double {
        return Double(ticks)*0.5
    }
    
    // Manipulate user data
    func charge(ticks:Int)
    {
        totalTicks -= ticks
        transactions.append(Transaction(date:Date(),type:.Charge,amount:ticks))
    }
    func credit(ticks:Int) {
        // if currentSessionTicksIncrement != 0 { error }
        totalTicks += ticks
        transactions.append(Transaction(date:Date(),type:.Credit,amount:ticks))
    }
    func credit(dollars:Double) {
        credit(ticks:Int(dollars*2.0+0.5))
    }
}
