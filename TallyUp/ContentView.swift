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

    @State var confirmingClear = false
    
    var balance : String {
        let absTicks = abs(userData.totalTicks)
        return "\(absTicks) - \(TallyUpUtil.dollarText(ticks:absTicks))"
    }
    var balanceColor : Color {
        return (userData.totalTicks) < 0 ? .red : .green
    }
    var numTransactions : Int {
        return userData.transactions.count
    }
    
    var body: some View {
        VStack {
            // Overal balance text on top of "Pay..." button
            
            HStack {
                Text("Current Balance")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            HStack {
                Spacer()
                Button( action : {} ) {
                    Text("Pay...")
                        .padding(.horizontal,6.0)
                        .padding(.vertical, 4.0)
                        .background(userData.totalTicks < 0 ? Color.red : Color.clear)
                        .foregroundColor(userData.totalTicks < 0 ? .white : .blue)
                }
                .padding(.trailing,6.0)
            }
            .padding(.vertical)
            .overlay(
                Text(balance)
                    .font(.largeTitle)
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.center)
            )
            
            // View to click up a new charge 
            
            HStack {
                Text("Add Item")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/)
            
            TickCounter(applyChange: { (increment:Int) -> Void in 
                do {
                    try self.userData.charge(ticks:increment)
                } catch {}
            } )
                .padding([.bottom])
            
            // Transaction history list
            
            HStack {
                Text("Transaction History")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    self.confirmingClear = true
                }) {
                    Text("Erase")
                }
                .disabled(numTransactions == 0)
                .alert(isPresented:$confirmingClear) {
                    Alert(title: Text(String(format:"Erase %@",TallyUpUtil.pluralize(numTransactions,"transaction",withPlural:"transactions"))), message: Text("This cannot be undone"), primaryButton: .destructive(Text("Erase")) {
                            do { try self.userData.clearTransactions() } catch {}
                    }, secondaryButton: .cancel())
                }
                .multilineTextAlignment(.trailing)
                .padding(.trailing)
            }
            TransactionHistory(transactions:userData.transactions)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
