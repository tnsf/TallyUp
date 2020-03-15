//
//  TallyDetail.swift
//  TallyUp
//
//  Created by Graeme Hiebert on 2020-02-17.
//  Copyright © 2020 Graeme Hiebert. All rights reserved.
//

import SwiftUI

struct TallyDetail: View {
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack(alignment: .leading, spacing:10.0) {
            // View to click up a new charge 
            
            Text("New Item")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            TickCounter(onApplyChange: { (increment:Int) -> Void in 
                do {
                    try self.userData.charge(ticks:increment)
                } catch {}
            } )
        }
    }
}

struct TallyDetail_Previews: PreviewProvider {
    static var previews: some View {
        TallyDetail()
        .environmentObject(UserData(balance:-33,currentTicks:12))
    }
}
