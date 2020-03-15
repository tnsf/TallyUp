//
//  ContentView.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-14.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State var payingUp = false
    @State var confirmingClear = false
    @State var unpaidTicks : Int = 0

    // Header indicating current mode

    var headerTitle : String {
        return payingUp ? "Payment" : "Current Balance";
    }

    // Content for "current value" display
    
    var displayedTicks : Int {
        return payingUp ? unpaidTicks : userData.totalTicks
    }
    var dollarBalance : String {
        let absTicks = abs(displayedTicks)
        return "\(TallyUpUtil.dollarText(ticks:absTicks))"
    }
    var balanceColor : Color {
        return payingUp ? Color.blue : TallyUpUtil.balanceColor(ticks:userData.totalTicks)
    }
    
    // Content for summary line of current value display
    
    var balanceSummary : String {
        let absTicks = abs(userData.totalTicks)
        let direction = (userData.totalTicks < 0) ? "owing" : "credit"
        return absTicks == 0 ? "" : "(\(absTicks) ticks \(direction))"
    }

    // Content for "transaction log"
    
    var numTransactions : Int { userData.transactions.count }
    
    // Main view body
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0.0) {
            
            Text(headerTitle)
                .font(.title)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Text(dollarBalance)
                    .font(.largeTitle)
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            if (self.payingUp)
            {
                AnyView(VStack(alignment:.leading, spacing: 0.0) {
                    PaymentDetail(tickBalance: self.userData.totalTicks,
                                  unsavedTicks: self.$unpaidTicks,
                                  onApplyChange: { (increment:Int) -> Void in 
                                    do {
                                        try self.userData.credit(ticks:increment)
                                    }
                                    catch {} },
                                  onDismiss: { self.payingUp = false } )
                    }
                )
            }
            else
            {
                AnyView(VStack(alignment:.leading, spacing: 0.0) {
                    VStack(spacing:0.0) {
                        ZStack {
                            HStack {
                                Spacer()
                                Button( action : {
                                    self.unpaidTicks = 0
                                    self.payingUp = true
                                }) {
                                    Text("Pay...")
                                        .padding(.horizontal,6.0)
                                        .background(userData.totalTicks < 0 ? Color.red : Color.clear)
                                        .foregroundColor(userData.totalTicks < 0 ? .white : .blue)
                                        .cornerRadius(3.0)
                                        .clipped()
                                }
                                .padding(.trailing,6.0)
                            }
                            
                            Text(balanceSummary)
                                .foregroundColor(balanceColor)
                                .multilineTextAlignment(.center)
                        }
                    }
                    TallyDetail()
                    }
                )
            }
            
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
