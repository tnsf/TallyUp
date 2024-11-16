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
    var amount : Int32
    
    enum TransactionType : String, Codable
    {
        var description: String
        {
            return self.rawValue
        }
        
        case Charge
        case Credit
    }
    
    init(date:Date = Date(), type:TransactionType = .Charge, amount:Int32 = 0)
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
    @Published var totalCents : Int32 = 0
    @Published var transactions : [Transaction] = [Transaction]()
    
    var failedToInit = false
    
    init() {
        do { try restore() } catch {}
    }
    
    init(balance:Int32 = 0, initialTransactions:[Transaction] = [Transaction]()) {
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
        let totalCents = try values.decodeIfPresent(Int32.self, forKey: .totalCents)
        if (totalCents == nil)
        {
            self.totalCents = (try values.decodeIfPresent(Int32.self, forKey: .totalTicks) ?? 0) * 50
            self.transactions = self.transactions.map {
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

        // Write out dates as an ISO8601 date string (with optional fractional seconds)
        encoder.dateEncodingStrategy = .custom({date, encoder in
            var container = encoder.singleValueContainer()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            try container.encode(formatter.string(from: date))
        })

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

        // Interpret detes in JSON data either as an ISO8601 date string (with optional
        // fractional seconds) or a time interval since 2001-01-01T00:00:00Z
        decoder.dateDecodingStrategy = .custom({decoder in
            let container = try decoder.singleValueContainer()
            if let dateString = try? container.decode(String.self) {
                let fractionalDateFormatter = ISO8601DateFormatter()
                fractionalDateFormatter.formatOptions.insert(.withFractionalSeconds)

                if let date = fractionalDateFormatter.date(from: dateString) {
                    return date
                } else if let date = ISO8601DateFormatter().date(from: dateString) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
            }
            else if let dateFloat = try? container.decode(Double.self) {
                return Date(timeIntervalSinceReferenceDate: dateFloat)
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date value")
          })
        let stored = try decoder.decode(UserData.self, from:json)
        totalCents = stored.totalCents
        transactions = stored.transactions
        
        return true
    }
    
    // Manipulate user data

    func charge(cents:Int32) throws {
        if (cents != 0)
        {
            totalCents -= cents
            transactions.append(Transaction(date:Date(),type:.Charge,amount:-cents))
            try save()
        }
    }
    func credit(cents:Int32) throws {
        totalCents += cents
        transactions.append(Transaction(date:Date(),type:.Credit,amount:cents))
        try save()
    }
    func credit(dollars:Double) throws {
        try credit(cents:Int32(dollars * 100.0 + 0.5))
    }
    func clearTransactions() throws {
        transactions = []
        try save()
    }
    func payInFull() throws {
        try credit(cents:-1 * totalCents)
    }
}
