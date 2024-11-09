//
//  PaymentView.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct PaymentDetail: View, TickCountable {
    var tickBalance : Int16
    @Binding var unsavedTicks : Int16
    var onApplyChange : ((Int16) -> Void)?
    var onDismiss : (() -> Void)?
    
    
    // Choose style of clickers: .PlusMinus or .Stepper
    let style : Clicker.Style = .Stepper
    
    var balanceSummary : String {
        let resulting = tickBalance+unsavedTicks
        let dollars = TallyUpUtil.dollarText(ticks: abs(resulting))
        let wrapped = (resulting < 0) ? "(\(dollars))" : dollars
        return "Resulting balance: \(wrapped)"
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing:0.0) {
                        
            VStack(spacing:12.0) {
                Clicker(counter:self, numCents:2000, style:style)
                Clicker(counter:self, numCents:500, style:style)
                Clicker(counter:self, numCents:200, style:style)
                Clicker(counter:self, numCents:100, style:style)
                Clicker(counter:self, numCents:50, style:style)
            }
            
            HStack(spacing:2.0) {
                Button(action: { self.onDismiss?() } ) {
                    HStack {
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                    .padding(.vertical,6.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
                    .padding(.horizontal,3.0)
                }
                
                Button(action: {
                    self.onApplyChange?(self.unsavedTicks)
                    self.onDismiss?()
                } ) {
                        HStack {
                            Spacer()
                            Text("Pay Now")
                            Spacer()
                        }
                        .padding(.vertical,6.0)
                        .background(unsavedTicks > 0 ? Color.red : Color.clear)
                        .foregroundColor(unsavedTicks > 0 ? Color.white : Color.gray)
                        .cornerRadius(8.0)
                        .padding(.horizontal,3.0)
                }
                .disabled(unsavedTicks==0)
            }
            .padding(.vertical,15.0)
        }
        .padding(.top,8.0)
    }
    
    // Actions
    func increment(_ numTicks:Int16) {
        unsavedTicks += numTicks
    }
    func decrement(_ numTicks:Int16) {
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
    @State static var ticksPaying : Int16 = 0

    static var previews: some View {
        PaymentDetail(tickBalance: 17,unsavedTicks:$ticksPaying)
    }
}
