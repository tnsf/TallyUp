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
        VStack(alignment: .leading, spacing: 10.0) {
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
                    .alert(isPresented: $presentingView) {
                        Alert(title: Text("Paying off balance of \(TallyUpUtil.dollarText(ticks:abs(userData.totalTicks)))"), message: Text("This cannot be undone"), primaryButton: .destructive(Text("Pay")) {
                            do { try self.userData.payInFull() } catch {}
                            }, secondaryButton: .cancel())
                    }
                }
                
                Text(balance)
                    .font(.largeTitle)
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.center)
            }
            
            // View to click up a new charge 
            
            Text("New Item")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            TickCounter(applyChange: { (increment:Int) -> Void in 
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
