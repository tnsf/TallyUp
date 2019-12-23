//
//  ContentView.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2019-12-14.
//  Copyright © 2019 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    
    func balance() -> String {
        return String(format:"%d - $%0.02f",Int(userData.totalTicks),Double(userData.totalTicks)*0.5)
    }
    var body: some View {
        VStack {
            HStack {
                Text("Current Balance")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Text(balance())
                .font(.largeTitle)
                .foregroundColor(Color.red)
                .multilineTextAlignment(.center)
            VStack {
                Clicker(numTicks:1)
                Clicker(numTicks:2)
                Clicker(numTicks:4)
            }
            .padding()
            Spacer()
            HStack {
                Spacer()
                Button(action:{self.userData.clear()}) {
                    Text("Clear")
                }                
                Button(action:{self.userData.apply()}) {
                    Text("Apply")
                }       
                Spacer()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
