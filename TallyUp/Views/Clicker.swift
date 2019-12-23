//
//  Clicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-22.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct Clicker: View {
    var numTicks = 1
    
    var body: some View {
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            Text(String(format: "%d - $%0.2f",self.numTicks,Double(self.numTicks)*0.5))
                .font(.title)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct Clicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Clicker(numTicks:1)
            Clicker(numTicks:2)
        }
    }
}
