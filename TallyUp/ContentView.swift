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
    
    var balance : String {
        let absTicks = abs(userData.totalTicks)
        return "\(absTicks) - \(UserData.dollarText(ticks:absTicks))"
    }
    var balanceColor : Color {
        return (userData.totalTicks) < 0 ? .red : .green 
    }
    var balanceModifier : String {
        let ticks = userData.totalTicks
        return (ticks < 0) ? "owing" : (ticks > 0) ? "credit" : ""
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Balance")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(balanceModifier)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
            }
            Text(balance)
                .font(.largeTitle)
                .foregroundColor(balanceColor)
                .multilineTextAlignment(.center)
            VStack {
                Clicker(numTicks:1)
                Clicker(numTicks:2)
                Clicker(numTicks:4)
            }
            .padding([.top, .leading, .trailing])
            VStack(alignment: .trailing) {
                Text("+\(userData.currentSessionTickIncrement) \((userData.currentSessionTickIncrement == 1) ? "tick" : "ticks")")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity((userData.currentSessionTickIncrement == 0) ? 0.0 : 1.0)
                HStack {
                    Button(action:{self.userData.clear()}) {
                        Text("Clear")
                        
                    }
                    .disabled(userData.currentSessionTickIncrement == 0)
                    Spacer()
                    Button(action:{self.userData.charge()}) {
                        Text("Apply")
                        
                    }
                    .disabled(userData.currentSessionTickIncrement == 0)       
                }
                .padding(.top, 8.0)
            }
            .padding([.leading, .bottom, .trailing])
            HStack {
                Text("Transaction History")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            TransactionHistory(transactions:userData.transactions)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
