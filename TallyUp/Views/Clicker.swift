//
//  Clicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-22.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct Clicker: View {
    var counter : TickCounter
    var numTicks = 1
    
    var body: some View {
        HStack {
            Button(action: {self.counter.decrement(self.numTicks)}) {
                Image(systemName:"minus")
            }
            Spacer()
            Text("\(self.numTicks) - \(UserData.dollarText(ticks:self.numTicks))")
                .font(.title)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {self.counter.increment(self.numTicks)}) {
                Image(systemName:"plus")
                    .frame(height: nil)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.horizontal, 20.0/*@END_MENU_TOKEN@*/)
    }
}

struct Clicker_Previews: PreviewProvider {
    static var counter = TickCounter()

    static var previews: some View {
        Group {
            Clicker(counter:self.counter, numTicks:1)
            Clicker(counter:self.counter, numTicks:2)
        }
    }
}
