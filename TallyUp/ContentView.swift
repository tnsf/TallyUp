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
    @State var unpaidCents : Int16 = 0

    // Content for "current value" display

    var displayedCents : Int16 {
        return payingUp ? unpaidCents : userData.totalCents
    }
    var dollarBalance : String {
        let absCents = abs(displayedCents)
        return "\(TallyUpUtil.dollarText(cents:absCents))"
    }
    var balanceColor : Color {
        return payingUp ? Color.blue : TallyUpUtil.balanceColor(cents:userData.totalCents)
    }

    // Content for summary line of current value display

    var balanceSummary : String {
        if (payingUp)
        {
            let resulting = userData.totalCents + unpaidCents
            let dollars = TallyUpUtil.dollarText(cents: abs(resulting))
            let wrapped = (resulting < 0) ? "(\(dollars))" : dollars
            return "Resulting balance: \(wrapped)"
        }
        else
        {
            return (userData.totalCents < 0) ? "owing" : "credit"
        }
    }
    var summaryColor : Color {
        return payingUp ? TallyUpUtil.balanceColor(cents:userData.totalCents + unpaidCents)
                        : TallyUpUtil.balanceColor(cents:userData.totalCents)
    }

    var summaryButton : some View {
        var text : String
        var foreground : Color
        var background : Color
        var onClick : (() -> Void)
        var disabled : Bool

        if (payingUp)
        {
            text = "Even Up"
            foreground = userData.totalCents >= 0 ? .gray : .white
            background = userData.totalCents >= 0 ? .clear : .blue
            onClick = {self.unpaidCents = -self.userData.totalCents}
            disabled = (userData.totalCents >= 0)
        }
        else
        {
            text = "Pay"
            foreground = userData.totalCents < 0 ? .white : .blue
            background = userData.totalCents < 0 ? .red : .clear
            onClick = {
                self.unpaidCents = 0
                self.payingUp = true
            }
            disabled = false
        }
        return Button (action:onClick)
        {
            Text(text)
                .padding(.horizontal, 6.0)
                .background(background)
                .foregroundColor(foreground)
                .cornerRadius(3.0)
                .clipped()
        }
        .padding(.trailing,6.0)
        .disabled(disabled)
    }

    // Content for "transaction log"

    var numTransactions : Int { userData.transactions.count }

    // Main view body

    var body: some View {
        VStack(alignment:.leading, spacing: 0.0) {

            // Dollar balance/summary line/action button

            HStack {
                Spacer()
                Text(dollarBalance)
                    .font(.largeTitle)
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.center)
                    .animation(.none)
                Spacer()
            }
            .animation(.none)

            ZStack {
                Text(balanceSummary)
                    .foregroundColor(summaryColor)
                    .multilineTextAlignment(.center)

                HStack {
                    Spacer()
                    summaryButton
                }
            }
            .padding(.bottom,6.0)
            .animation(.none)

            // "Tally up" or "Make payment" view

            if (self.payingUp)
            {
                AnyView(VStack(alignment: .leading, spacing:10.0) {
                    Text("Payment")
                        .font(.title)
                        .multilineTextAlignment(.leading)

                    PaymentDetail(centBalance: self.userData.totalCents,
                                  unsavedCents: self.$unpaidCents,
                                  onApplyChange: { (increment:Int16) -> Void in
                                    do {
                                        try self.userData.credit(cents:increment)
                                    }
                                    catch {} },
                                  onDismiss: { self.payingUp = false } )
                        .padding(.bottom,6.0)
                })
//                .transition(.asymmetric(insertion: .scale, removal: .scale))
                    .transition(.opacity)

            }
            else
            {
                AnyView(VStack(alignment: .leading, spacing:10.0) {
                    Text("New Item")
                        .font(.title)
                        .multilineTextAlignment(.leading)

                    CentCounter(onApplyChange: { (increment:Int16) -> Void in
                        do {
                            try self.userData.charge(cents:increment)
                        } catch {}
                    } )
                    }
                )
//                .transition(.asymmetric(insertion: .scale, removal: .scale))
                    .transition(.opacity)
            }

            // Transaction history list

            VStack(alignment: .leading, spacing: 10.0) {
                Text("Transaction Log")
                    .font(.title)
                    .multilineTextAlignment(.leading)

                TransactionHistory(transactions:userData.transactions)
                    .padding(.horizontal)

                Button(action: {
                    self.confirmingClear = true
                }) {
                    Text("Clear Log")
                }
                .disabled(numTransactions == 0)
                .padding(.leading, 6.0)
                .alert(isPresented:$confirmingClear) {
                    Alert(title: Text(String(format:"Erase %@",TallyUpUtil.pluralize(numTransactions,"transaction",withPlural:"transactions"))), message: Text("This cannot be undone"), primaryButton: .destructive(Text("Erase")) {
                        do { try self.userData.clearTransactions() } catch {}
                    }, secondaryButton: .cancel())
                }
            }
        }
        .animation(.default)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData(balance:-33,initialTransactions:[Transaction(date:Date(timeIntervalSinceNow: TimeInterval(15.9e6)),type:.Charge,amount:1),
                                                                                  Transaction(date:Date(),type:.Charge,amount:1)]))
    }
}
