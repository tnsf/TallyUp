//
//  ChargeTicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TickCounter: View, TickCountable {
    @State var unsavedTicks = UserDefaults.standard.integer(forKey: "TransactionUnsavedTicks")
    var onApplyChange : ((Int) -> Void)?

    // Choose style of clickers: .PlusMinus or .Stepper
    let style : Clicker.Style = .Stepper
    
    var body: some View {
        VStack(spacing:0.0) {
            // Add clickers for one, two, four ticks.
            
            VStack(spacing:12.0) {
                Clicker(counter:self, numTicks:1, style:style)
                Clicker(counter:self, numTicks:2, style:style)
                Clicker(counter:self, numTicks:4, style:style)
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
                        .background(unsavedTicks == 0 ? Color.clear : Color.gray)
                        .foregroundColor(unsavedTicks == 0 ? .gray : .white)
                        .cornerRadius(8.0)
                    }
                    .disabled(unsavedTicks == 0)
                    
                    Button(action:{self.charge()}) {
                        HStack {
                            Spacer()
                            Text(unsavedTicks == 0 ? "Apply" : "Apply " + TallyUpUtil.pluralize($unsavedTicks.wrappedValue, "tick", withPlural:"ticks"))
                            Spacer()
                        }
                        .padding(.horizontal,3.0)
                        .padding(.vertical,6.0)
                        .background(unsavedTicks == 0 ? Color.clear : /*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                        .foregroundColor(unsavedTicks == 0 ? .gray : .white)
                        .cornerRadius(8.0)
                        .clipped()
                        .disabled(unsavedTicks==0)
                    }
                    .disabled(unsavedTicks == 0)
                }
                .padding(.horizontal, 6.0)
                .padding(.top, 8.0)
            }
        }
    }
    
    // Helpers
    func updateCount(_ ticks:Int) {
        unsavedTicks = ticks;
        // Save tick count in user preferences
        UserDefaults.standard.set(self.unsavedTicks, forKey: "TransactionUnsavedTicks")
    }
    
    // Actions
    func increment(_ numTicks:Int = 1) {
        updateCount(unsavedTicks + numTicks)
    }
    func decrement(_ numTicks:Int = 1) {
        let finalNumTicks = unsavedTicks-numTicks
        if (finalNumTicks > 0)
        {
            updateCount(finalNumTicks)
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
        if unsavedTicks > 0
        {
            onApplyChange?(unsavedTicks)
        }
        clear()
    }
}

struct TickCounter_Previews: PreviewProvider {
    static var previews: some View {
        TickCounter(unsavedTicks:3)
    }
}
