//
//  ChargeTicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-01-02.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TickCounter: View {
    @State var currentIncrement : Int = 0
    var applyChange : ((Int) -> Void)?
    
    var body: some View {
        VStack {
            // Add clickers for one, two, four ticks.
            
            VStack {
                Clicker(counter:self, numTicks:1)
                Clicker(counter:self, numTicks:2)
                    .padding(.vertical)
                Clicker(counter:self, numTicks:4)
            }
            .padding(.horizontal)
            
            VStack(alignment: .trailing) {
                // Current tick count
                Text("+\(currentIncrement) \((currentIncrement == 1) ? "tick" : "ticks")")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity((currentIncrement == 0) ? 0.0 : 1.0)
                
                // Action buttons

                HStack {
                    Button(action:{self.clear()}) {
                        Text("Clear")
                    }
                    .disabled(currentIncrement == 0)
                    
                    Spacer()
                    
                    Button(action:{self.charge()}) {
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
        }
    }
    
    // Actions
    func increment(_ numTicks:Int = 1) {
        currentIncrement += numTicks
    }
    func decrement(_ numTicks:Int = 1) {
        let finalNumTicks = currentIncrement-numTicks
        if (finalNumTicks > 0)
        {
            currentIncrement = finalNumTicks
        }
        else
        {
            currentIncrement = 0
        }
    }
    func clear()
    {
        currentIncrement = 0
    }
    func charge()
    {
        if currentIncrement > 0
        {
            applyChange?(currentIncrement)
        }
        clear()
    }
}

struct TickCounter_Previews: PreviewProvider {
    static var previews: some View {
        TickCounter()
    }
}
