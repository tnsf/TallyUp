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
    
    var dollarBalance : String {
        let absTicks = abs(userData.totalTicks)
        return "\(TallyUpUtil.dollarText(ticks:absTicks))"
    }
    var tickBalance : String {
        let absTicks = abs(userData.totalTicks)
        let direction = (userData.totalTicks < 0) ? "owing" : "credit"
        return absTicks == 0 ? "" : "(\(absTicks) ticks \(direction))"
    }
    var balanceColor : Color {
        return TallyUpUtil.balanceColor(ticks:userData.totalTicks)
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10.0) {

            Text("Current Balance")
                .font(.title)
                .multilineTextAlignment(.leading)

            VStack(spacing:0.0) {
                HStack {
                    Spacer()
                    Text(dollarBalance)
                        .font(.largeTitle)
                        .foregroundColor(balanceColor)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                
                ZStack {
                    HStack {
                        Spacer()
                        Button( action : {
                            self.presentingView = true
                        }) {
                            Text("Pay...")
                                .padding(.horizontal,6.0)
                                .padding(.vertical,4.0)
                                .background(userData.totalTicks < 0 ? Color.red : Color.clear)
                                .foregroundColor(userData.totalTicks < 0 ? .white : .blue)
                                .cornerRadius(3.0)
                                .clipped()
                        }
                        .padding(.trailing,6.0)
                        .sheet(isPresented: $presentingView) {
                            PaymentDetail(tickBalance: self.userData.totalTicks,
                                          onApplyChange: { (increment:Int) -> Void in 
                                            do {
                                                try self.userData.credit(ticks:increment)
                                            }
                                            catch {} },
                                          onDismiss: { self.presentingView = false } )
                        }
                    }
                    
                    VStack {
                        Text(tickBalance)
                            .foregroundColor(balanceColor)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            
            TallyDetail()
            // Instead of using sheet above, maybe switch out TallyDetail
            // with PaymentDetail(tickBalance: self.userData.totalTicks)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
