//
//  CentCounter.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct CentCounter: View, CentCountable {
    @State var unsavedCents : Int32 = Int32(UserDefaults.standard.integer(forKey: "TransactionUnsavedCents"))
    var onApplyChange : ((Int32) -> Void)?

    // Choose style of clickers: .PlusMinus or .Stepper
    let style : Clicker.Style = .Stepper
    
    var body: some View {
        VStack(spacing:0.0) {
            // Add clickers for $0.25, $0.50, $0.75, $1.00, $2.00

            VStack(spacing:12.0) {
                Clicker(counter:self, numCents:25, style:style)
                Clicker(counter:self, numCents:50, style:style)
                Clicker(counter:self, numCents:75, style:style)
                Clicker(counter:self, numCents:100, style:style)
                Clicker(counter:self, numCents:200, style:style)
            }
            
            VStack(alignment: .trailing) {                
                // Action buttons
                
                HStack {
                    Button(action:{self.clear()}) {
                        HStack {
                            Spacer()
                            Text("Clear Item")
                            Spacer()
                        }
                        .padding(.horizontal,3.0)
                        .padding(.vertical,6.0)
                        .background(unsavedCents == 0 ? Color.clear : Color.gray)
                        .foregroundColor(unsavedCents == 0 ? .gray : .white)
                        .cornerRadius(8.0)
                    }
                    .disabled(unsavedCents == 0)
                    
                    Button(action:{self.charge()}) {
                        HStack {
                            Spacer()
                            Text(unsavedCents == 0 ? "Charge" : "Charge \(TallyUpUtil.dollarText(cents:Int32($unsavedCents.wrappedValue)))")
                            Spacer()
                        }
                        .padding(.horizontal,3.0)
                        .padding(.vertical,6.0)
                        .background(unsavedCents == 0 ? Color.clear : /*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                        .foregroundColor(unsavedCents == 0 ? .gray : .white)
                        .cornerRadius(8.0)
                        .clipped()
                        .disabled(unsavedCents==0)
                    }
                    .disabled(unsavedCents == 0)
                }
                .padding(.horizontal, 6.0)
                .padding(.top, 8.0)
            }
        }
    }
    
    // Helpers
    func updateCount(_ cents:Int32) {
        unsavedCents = cents;
        // Save cent count in user preferences
        UserDefaults.standard.set(self.unsavedCents, forKey: "TransactionUnsavedCents")
    }
    
    // Actions
    func increment(_ numCents:Int32 = 1) {
        updateCount(unsavedCents + numCents)
    }
    func decrement(_ numCents:Int32 = 1) {
        let finalNumCents = unsavedCents-numCents
        if (finalNumCents > 0)
        {
            updateCount(finalNumCents)
        }
        else
        {
            updateCount(0)
        }
    }
    func clear()
    {
        updateCount(0)
    }
    func charge()
    {
        if unsavedCents > 0
        {
            onApplyChange?(unsavedCents)
        }
        clear()
    }
}

struct CentCounter_Previews: PreviewProvider {
    static var previews: some View {
        CentCounter(unsavedCents:3)
    }
}
