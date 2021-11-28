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
        ScrollView {
            VStack {
                ForEach(transactions.sorted(by:>)) {
                    TransactionRow(transaction:$0)
                }
            }
        }
    }
}

struct TransactionHistory_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionHistory(transactions:[Transaction(date:Date(timeIntervalSinceNow: TimeInterval(15.9e6)),type:.Charge,amount:1),
                                             Transaction(date:Date(),type:.Charge,amount:1)])
        }
    }
}
