//
//  UserData.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-23.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import Foundation

struct Transaction : Identifiable, Comparable, Codable
{
    var id: UUID
    
    var date : Date
    var type : TransactionType
    var amount : Int
    
    enum TransactionType : String, Codable
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

final class UserData : ObservableObject, Codable {
    @Published var totalTicks = 0
    @Published var transactions : [Transaction] = [Transaction]()
    
    var failedToInit = false
    
    init() {
        do { try restore() } catch {}
    }
    
    init(balance:Int = 0,currentTicks:Int = 0) {
        totalTicks = balance
    }
    
    // Persistence
    enum CodingKeys: String, CodingKey {
        case version, totalTicks, transactions
    }
    
    func docDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        totalTicks = try values.decode(Int.self, forKey: .totalTicks)
        transactions = try values.decode([Transaction].self, forKey: .transactions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(totalTicks, forKey: .totalTicks)
        try container.encode(transactions, forKey: .transactions)
    }
    
    @discardableResult func save() throws -> Bool {
        // Don't attempt to write in the case where initial restore failed, as it might
        // be due to a bug & we don't want to lose our stored data

        if failedToInit { return false }

        let encoder = JSONEncoder()
        // encoder.outputFormatting = .prettyPrinted
        
        // Write data to file
        let json =  try encoder.encode(self)
        var file = docDirectory();
        file.appendPathComponent("TallyUpData.json")
        try json.write(to:file)
        
        return true
    }
    
    @discardableResult func restore() throws -> Bool {
        // Read data from file
        
        var file = docDirectory();
        file.appendPathComponent("TallyUpData.json")

        let json = try Data(contentsOf: file)
        
        let decoder = JSONDecoder()
        let stored = try decoder.decode(UserData.self, from:json)
        totalTicks = stored.totalTicks
        transactions = stored.transactions
        
        return true
    }
    
    // Manipulate user data

    func charge(ticks:Int) throws {
        if (ticks != 0)
        {
            totalTicks -= ticks
            transactions.append(Transaction(date:Date(),type:.Charge,amount:-ticks))
            try save()
        }
    }
    func credit(ticks:Int) throws {
        totalTicks += ticks
        transactions.append(Transaction(date:Date(),type:.Credit,amount:ticks))
        try save()
    }
    func credit(dollars:Double) throws {
        try credit(ticks:Int(dollars*2.0+0.5))
    }
    func clearTransactions() throws {
        transactions = []
        try save()
    }
    func payInFull() throws {
        try credit(ticks:-1 * totalTicks)
    }
}
