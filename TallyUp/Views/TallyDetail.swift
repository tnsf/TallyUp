//
//  TallyDetail.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-02-17.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TallyDetail: View {
    @EnvironmentObject var userData: UserData

    @State var confirmingClear = false
    
    var numTransactions : Int { userData.transactions.count }
    
    var body: some View {
        VStack(alignment: .leading, spacing:10.0) {
            // View to click up a new charge 
            
            Text("New Item")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            TickCounter(onApplyChange: { (increment:Int) -> Void in 
                do {
                    try self.userData.charge(ticks:increment)
                } catch {}
            } )
            
            // Transaction history list
            
            VStack(alignment: .leading, spacing: 6.0) {
                Text("Transaction Log")
                    .font(.title)
                    .multilineTextAlignment(.leading)
            }
            TransactionHistory(transactions:userData.transactions)
            Button(action: {
                self.confirmingClear = true
            }) {
                Text("Clear Log")
            }
            .disabled(numTransactions == 0)
            .padding(.leading)
            .alert(isPresented:$confirmingClear) {
                Alert(title: Text(String(format:"Erase %@",TallyUpUtil.pluralize(numTransactions,"transaction",withPlural:"transactions"))), message: Text("This cannot be undone"), primaryButton: .destructive(Text("Erase")) {
                    do { try self.userData.clearTransactions() } catch {}
                    }, secondaryButton: .cancel())
            }
        }
    }
}

struct TallyDetail_Previews: PreviewProvider {
    static var previews: some View {
        TallyDetail()
        .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
