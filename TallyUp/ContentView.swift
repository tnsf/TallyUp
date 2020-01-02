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

    var currentIncrement : Int {
        return userData.currentSessionTickIncrement
    }
    
    var body: some View {
        VStack {
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
            
            VStack {
                Clicker(numTicks:1)
                Clicker(numTicks:2)
                    .padding(.vertical)
                Clicker(numTicks:4)
            }
            .padding(.horizontal)
            VStack(alignment: .trailing) {
                Text("+\(currentIncrement) \((currentIncrement == 1) ? "tick" : "ticks")")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity((currentIncrement == 0) ? 0.0 : 1.0)
                HStack {
                    Button(action:{self.userData.clear()}) {
                        Text("Clear")
                        
                    }
                    .disabled(currentIncrement == 0)
                    Spacer()
                    Button(action:{self.userData.charge()}) {
                        Text("Apply")
                            .padding(.horizontal)
                            .padding(.vertical, 4.0)
                            .background(currentIncrement == 0 ? Color.white : /*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                            .foregroundColor(currentIncrement == 0 ? .gray : .white)
                        
                    }
                    .disabled(currentIncrement == 0)       
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
