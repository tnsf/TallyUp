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
    var amount : Int16
    
    enum TransactionType : String, Codable
    {
        var description: String
        {
            return self.rawValue
        }
        
        case Charge
        case Credit
    }
    
    init(date:Date = Date(), type:TransactionType = .Charge, amount:Int16 = 0)
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
    @Published var totalCents : Int16 = 0
    @Published var transactions : [Transaction] = [Transaction]()
    
    var failedToInit = false
    
    init() {
        do { try restore() } catch {}
    }
    
    init(balance:Int16 = 0, initialTransactions:[Transaction] = [Transaction]()) {
        totalCents = balance
        transactions = initialTransactions
    }
    
    // Persistence
    enum CodingKeys: String, CodingKey {
        case totalTicks, totalCents, transactions
    }
    
    func docDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.transactions = try values.decode([Transaction].self, forKey: .transactions)

        // New files make "totalCents". Old files had "totalTicks", repreenting either $0.50 ticks.
        // Here we math our way out of ticks on import
        let totalCents = try values.decodeIfPresent(Int16.self, forKey: .totalCents)
        if (totalCents == nil)
        {
            self.totalCents = (try values.decodeIfPresent(Int16.self, forKey: .totalTicks) ?? 0) * 50
            transactions = transactions.map {
                var t = $0
                t.amount *= 50
                return t
            }
        }
        else
        {
            self.totalCents = totalCents!
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(totalCents, forKey: .totalCents)
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
        totalCents = stored.totalCents
        transactions = stored.transactions
        
        return true
    }
    
    // Manipulate user data

    func charge(cents:Int16) throws {
        if (cents != 0)
        {
            totalCents -= cents
            transactions.append(Transaction(date:Date(),type:.Charge,amount:-cents))
            try save()
        }
    }
    func credit(cents:Int16) throws {
        totalCents += cents
        transactions.append(Transaction(date:Date(),type:.Credit,amount:cents))
        try save()
    }
    func credit(dollars:Double) throws {
        try credit(cents:Int16(dollars * 100.0 + 0.5))
    }
    func clearTransactions() throws {
        transactions = []
        try save()
    }
    func payInFull() throws {
        try credit(cents:-1 * totalCents)
    }
}
