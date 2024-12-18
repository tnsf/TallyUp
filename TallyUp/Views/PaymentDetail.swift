//
//  PaymentView.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct PaymentDetail: View, CentCountable {
    var centBalance : Int32
    @Binding var unsavedCents : Int32
    var onApplyChange : ((Int32) -> Void)?
    var onDismiss : (() -> Void)?
    
    
    // Choose style of clickers: .PlusMinus or .Stepper
    let style : Clicker.Style = .Stepper
    
    var balanceSummary : String {
        let resulting = centBalance+unsavedCents
        let dollars = TallyUpUtil.dollarText(cents: abs(resulting))
        let wrapped = (resulting < 0) ? "(\(dollars))" : dollars
        return "Resulting balance: \(wrapped)"
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing:0.0) {
                        
            // Add clickers for $20.00, $5.00, $2.00, $1.00, $0.50

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
                    self.onApplyChange?(self.unsavedCents)
                    self.onDismiss?()
                } ) {
                        HStack {
                            Spacer()
                            Text("Pay Now")
                            Spacer()
                        }
                        .padding(.vertical,6.0)
                        .background(unsavedCents > 0 ? Color.red : Color.clear)
                        .foregroundColor(unsavedCents > 0 ? Color.white : Color.gray)
                        .cornerRadius(8.0)
                        .padding(.horizontal,3.0)
                }
                .disabled(unsavedCents==0)
            }
            .padding(.vertical,15.0)
        }
        .padding(.top,8.0)
    }
    
    // Actions
    func increment(_ numCents:Int32) {
        unsavedCents += numCents
    }
    func decrement(_ numCents:Int32) {
        let finalNumCents = unsavedCents-numCents
        if (finalNumCents > 0)
        {
            unsavedCents = finalNumCents
        }
        else
        {
            unsavedCents = 0
        }
    }
    func clear()
    {
        unsavedCents = 0
    }
}

struct PaymentDetail_Previews: PreviewProvider {
    @State static var showingPayment = false
    @State static var centsPaying : Int32 = 0

    static var previews: some View {
        PaymentDetail(centBalance: 17,unsavedCents:$centsPaying)
    }
}
