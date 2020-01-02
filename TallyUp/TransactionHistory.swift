//
//  TransactionHistory.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TransactionHistory: View {
    var transactions : [Transaction]

    var body: some View {
        List(transactions.sorted(by:>)) { transaction in
            TransactionRow(transaction:transaction)
        }
    }
}

struct TransactionHistory_Previews: PreviewProvider {
    static var previews: some View {
        TransactionHistory(transactions:[Transaction(date:Date(timeIntervalSinceNow: TimeInterval(357.0)),type:.Charge,amount:1),
                                         Transaction(date:Date(),type:.Charge,amount:1)])
    }
}
