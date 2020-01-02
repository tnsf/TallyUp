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
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Balance")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            // Overal balance text on top of "Pay..." button
            
            HStack {
                Spacer()
                Button( action : {} ) {
                    Text("Pay...")
                        .padding(.horizontal)
                        .padding(.vertical, 4.0)
                        .background(userData.totalTicks < 0 ? Color.red : Color.white)
                        .foregroundColor(userData.totalTicks < 0 ? .white : .blue)
                }
            }
            .padding(.vertical)
            .overlay(
                Text(balance)
                    .font(.largeTitle)
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.center)
            )
            HStack {
                Text("Add Item")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/)
            TickCounter()
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
