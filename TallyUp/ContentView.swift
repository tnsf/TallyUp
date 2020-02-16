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
    
    @State var presentingView = false
    @State var confirmingClear = false
    
    var dollarBalance : String {
        let absTicks = abs(userData.totalTicks)
        return "\(TallyUpUtil.dollarText(ticks:absTicks))"
    }
    var tickBalance : String {
        return "(\(userData.totalTicks) ticks)"
    }
    var balanceColor : Color {
        return TallyUpUtil.balanceColor(ticks:userData.totalTicks)
    }
    var numTransactions : Int {
        return userData.transactions.count
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10.0) {
            // Overal balance text on top of "Pay..." button
            
            Text("Current Balance")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            ZStack {
                HStack {
                    Spacer()
                    Button( action : {
                        self.presentingView = true
                    }) {
                        Text("Pay...")
                            .padding(.horizontal,6.0)
                            .padding(.vertical, 4.0)
                            .background(userData.totalTicks < 0 ? Color.red : Color.clear)
                            .foregroundColor(userData.totalTicks < 0 ? .white : .blue)
                            .cornerRadius(3.0)
                            .clipped()
                    }
                    .padding(.trailing,6.0)
                        .sheet(isPresented: $presentingView) {
                            PaymentDetail(tickBalance: self.userData.totalTicks,
                                          isPresented: self.$presentingView,
                                          onApplyChange: { (increment:Int) -> Void in 
                                            do {
                                                try self.userData.credit(ticks:increment)
                                            } catch {}
                            })
                    }
                }
     
                VStack {
                    Text(dollarBalance)
                        .font(.largeTitle)
                        .foregroundColor(balanceColor)
                        .multilineTextAlignment(.center)
                    
                    Text(tickBalance)
                        .foregroundColor(balanceColor)
                        .multilineTextAlignment(.center)
                }
            }
            
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
