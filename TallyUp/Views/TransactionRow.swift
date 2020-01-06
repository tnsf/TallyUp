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
        dateFormatter.dateFormat = "EEE MM/dd HH:mm"//"YYYY/MM/dd HH:mm"
        
        return dateFormatter.string(from:transaction.date)
    }
    func amount() -> String {
        let sign = (transaction.type == .Charge) ? "-" : "+";
        return sign + TallyUpUtil.dollarText(ticks:abs(transaction.amount))
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) { // Stack invisible text element to align column to a maximum length
                Text("XXX XX/XX XX:XX")
                    .opacity(0.0)
                Text(date())
            }
            Spacer()
            ZStack(alignment: .leading) { // Stack invisible text element to align column to a maximum length
                Text("XXXXXX")
                    .opacity(0.0)
                Text(transaction.type.rawValue)
            }
            Spacer()
            ZStack(alignment: .trailing) { // Stack invisible text element to align column to a maximum length
                Text("-$000.00")
                    .opacity(0.0)
                Text(amount())
                    .foregroundColor((transaction.type == .Charge) ? Color.red : Color.green)
            }
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionRow(transaction:Transaction(date:Date(),type:.Charge,amount:1))
            TransactionRow(transaction:Transaction(date:Date(),type:.Credit,amount:3))
        }
    }
}
