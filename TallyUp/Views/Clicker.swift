//
//  Clicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-22.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

protocol TickCountable {
    func increment(_ numTicks:Int16)
    func decrement(_ numTicks:Int16)
}

struct Clicker: View {
    enum Style {
        case Stepper, PlusMinus        
    }
    
    var counter : TickCountable
    var numTicks : Int16 = 1
    var style : Style = .Stepper
    var showTicks : Bool = true
    
    var labelTicks : String { showTicks ? "\(numTicks) - " : ""}
    var label: String { "\(labelTicks)\(TallyUpUtil.dollarText(ticks:numTicks))" }
    
    var plusMinusView : some View {
        HStack {
            Button(action: {self.decrement()}) {
                Image(systemName:"minus")
                    .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            Text(label)
                .font(.title)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {self.increment()}) {
                Image(systemName:"plus")
                    .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    var stepperView : some View {
        Stepper(onIncrement: {self.increment()},
                onDecrement: {self.decrement()},
                label:{
                    HStack {
                        Spacer()
                        Button(action: {self.increment()})
                        {
                            Text(self.label)
                                .font(.title)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
            })
    }
    
    var body: some View {
        var widget : AnyView?
        switch (style)
        {
        case .PlusMinus:
            widget = AnyView(plusMinusView)
            
        case .Stepper:
            widget = AnyView(stepperView)
        }
        return widget.padding(.horizontal,20.0)
    }
    
    // Actions
    func increment() -> Void {
        counter.increment(numTicks)
    }
    func decrement() -> Void {
        counter.decrement(numTicks)
    }
    
}

struct Clicker_Previews: PreviewProvider {
    static var counter = TickCounter()
    
    static var previews: some View {
        Group {
            Clicker(counter:self.counter, numTicks:1, style:.PlusMinus)
            Clicker(counter:self.counter, numTicks:2)
        }
    }
}
