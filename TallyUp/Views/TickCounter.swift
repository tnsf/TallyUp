//
//  ChargeTicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TickCounter: View {
    @State var unsavedTicks = UserDefaults.standard.integer(forKey: "TransactionUnsavedTicks")
    var applyChange : ((Int) -> Void)?
    
    var body: some View {
        VStack {
            // Add clickers for one, two, four ticks.
            
            VStack(spacing: 6.0) {
                Clicker(counter:self, numTicks:1)
                Clicker(counter:self, numTicks:2)
                    .padding(.vertical,4.0)
                Clicker(counter:self, numTicks:4)
            }
            
            VStack(alignment: .trailing) {
                // Current tick count
                Text(TallyUpUtil.pluralize($unsavedTicks.wrappedValue, "tick", withPlural:"ticks"))
                    .padding(.trailing, 8.0)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity((unsavedTicks == 0) ? 0.0 : 1.0)
                
                // Action buttons

                HStack {
                    Button(action:{self.clear()}) {
                        Text("Clear")
                            .padding(.leading, 6.0)
                    }
                    .disabled(unsavedTicks == 0)
                    
                    Spacer()
                    
                    Button(action:{self.charge()}) {
                        Text("Apply")
                            .padding(.horizontal, 6.0)
                            .padding(.vertical, 4.0)
                            .background(unsavedTicks == 0 ? Color.clear : /*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                            .foregroundColor(unsavedTicks == 0 ? .gray : .white)
                        
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
            applyChange?(unsavedTicks)
        }
        clear()
    }
}

struct TickCounter_Previews: PreviewProvider {
    static var previews: some View {
        TickCounter()
    }
}
