//
//  Clicker.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-22.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

protocol CentCountable {
    func increment(_ numCents:Int32)
    func decrement(_ numCents:Int32)
}

struct Clicker: View {
    enum Style {
        case Stepper, PlusMinus        
    }
    
    var counter : CentCountable
    var numCents : Int32 = 1
    var style : Style = .Stepper

    var label: String { "\(TallyUpUtil.dollarText(cents:numCents))" }

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
        counter.increment(numCents)
    }
    func decrement() -> Void {
        counter.decrement(numCents)
    }
    
}

struct Clicker_Previews: PreviewProvider {
    static var counter = CentCounter()
    
    static var previews: some View {
        Group {
            Clicker(counter:self.counter, numCents:50, style:.PlusMinus)
            Clicker(counter:self.counter, numCents:100)
        }
    }
}
