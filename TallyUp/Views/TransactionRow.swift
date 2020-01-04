//
//  TransactionRow.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-29.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TransactionRow: View {
    var transaction : Transaction
    
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        
        return dateFormatter.string(from:transaction.date)
    }
    func amount() -> String {
        return TallyUpUtil.dollarText(ticks:transaction.amount)
    }

    var body: some View {
        HStack {
            Text(date())
            Spacer()
            Text(transaction.type.rawValue)
            Spacer()
            Text(amount())
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction:Transaction(date:Date(),type:.Charge,amount:1))
    }
}
