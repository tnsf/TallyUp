//
//  PaymentView.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct PaymentDetail: View, TickCountable {
    var tickBalance : Int
    @Binding var isPresented: Bool
    var onApplyChange : ((Int) -> Void)?

    @State var unsavedTicks = 0

    // Choose style of clickers: .PlusMinus or .Stepper
    let style : Clicker.Style = .Stepper
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                Text("Payment:")
                    .font(.title)
                    .foregroundColor(.blue)
                }
                .multilineTextAlignment(.leading)
                
                ZStack(alignment: .trailing) { // Stack invisible text element to align column to a maximum length
                    Text("$000.00")
                        .opacity(0.0)
                    Text(TallyUpUtil.dollarText(ticks:unsavedTicks))
                        .foregroundColor(Color.blue)
                        .multilineTextAlignment(.center)
                }
                .font(.largeTitle)
            }

            VStack(spacing:12.0) {
                Clicker(counter:self, numTicks:40, style:style, showTicks:false)
                Clicker(counter:self, numTicks:20, style:style, showTicks:false)
                Clicker(counter:self, numTicks:10, style:style, showTicks:false)
                Clicker(counter:self, numTicks:4, style:style, showTicks:false)
                Clicker(counter:self, numTicks:2, style:style, showTicks:false)
                Clicker(counter:self, numTicks:1, style:style, showTicks:false)
            }

            HStack {
                Spacer()
                Text("Resulting balance: \(TallyUpUtil.dollarText(ticks: abs(self.tickBalance+self.unsavedTicks)))")
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(TallyUpUtil.balanceColor(ticks:tickBalance+unsavedTicks))
            }
            .padding(.vertical)
            .padding(.horizontal,6.0)
            
            HStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.isPresented = false } ) {
                            Text("Cancel")
                    }
                    Spacer()
                }
                .padding(.vertical)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8.0)
                .padding(.horizontal,3.0)
                
                HStack {
                    Spacer()
                    Button(action: { self.onApplyChange?(self.unsavedTicks)
                        self.isPresented = false } ) {
                            Text("Pay Now")
                    }
                    Spacer()
                }
                .padding(.vertical)
                .background(Color.red)
                .cornerRadius(8.0)
                .foregroundColor(.white)
                .padding(.horizontal,3.0)
            }
        }
    }
    
    // Actions
    func increment(_ numTicks:Int) {
        unsavedTicks += numTicks
    }
    func decrement(_ numTicks:Int) {
        let finalNumTicks = unsavedTicks-numTicks
        if (finalNumTicks > 0)
        {
            unsavedTicks = finalNumTicks
        }
        else
        {
            unsavedTicks = 0
        }
    }
    func clear()
    {
        unsavedTicks = 0
    }
}

struct PaymentDetail_Previews: PreviewProvider {
    @State static var showingPayment = false

    static var previews: some View {
        PaymentDetail(tickBalance: 17, isPresented: $showingPayment)
    }
}
