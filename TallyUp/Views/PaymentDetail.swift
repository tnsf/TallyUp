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
    
    var balanceMessage : String {
        let resulting = tickBalance+unsavedTicks
        let dollars = TallyUpUtil.dollarText(ticks: abs(resulting))
        let wrapped = (resulting < 0) ? "(\(dollars))" : dollars
        return "Resulting balance: \(wrapped)"
    }
    
    var body: some View {
        VStack {
            VStack(alignment:.trailing,spacing:0.0) {
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
                
                Text(balanceMessage)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(TallyUpUtil.balanceColor(ticks:tickBalance+unsavedTicks))
            }
            
            HStack {
                Button(action:{self.unsavedTicks = 0}) {
                    Text("Clear")
                        .padding(.leading, 6.0)
                }
                .disabled(unsavedTicks == 0)
                
                Spacer()
                
                Button (action:{self.unsavedTicks = -self.tickBalance})
                {
                    Text("Pay In Full")
                        .padding(.horizontal, 6.0)
                        .padding(.vertical, 4.0)
                        .foregroundColor(tickBalance == 0 ? .gray : .blue)
                        .cornerRadius(3.0)
                        .clipped()
                }
                .disabled(tickBalance == 0)
            }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 8.0)
            
            VStack(spacing:12.0) {
                Clicker(counter:self, numTicks:40, style:style, showTicks:false)
                Clicker(counter:self, numTicks:20, style:style, showTicks:false)
                Clicker(counter:self, numTicks:10, style:style, showTicks:false)
                Clicker(counter:self, numTicks:4, style:style, showTicks:false)
                Clicker(counter:self, numTicks:2, style:style, showTicks:false)
                Clicker(counter:self, numTicks:1, style:style, showTicks:false)
            }
            
            HStack(spacing:2.0) {
                Button(action: { self.isPresented = false } ) {
                    HStack {
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                    .padding(.vertical)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
                    .padding(.horizontal,3.0)
                }
                
                Button(action: {
                    self.onApplyChange?(self.unsavedTicks)
                    self.isPresented = false
                } ) {
                        HStack {
                            Spacer()
                                    Text("Pay Now")
                            Spacer()
                        }
                        .padding(.vertical)
                        .background(Color.red)
                        .cornerRadius(8.0)
                        .foregroundColor(.white)
                        .padding(.horizontal,3.0)
                }
            }
            .padding(.top,30.0)
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
