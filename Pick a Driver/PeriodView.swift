//
//  PeriodView.swift
//  Pick a Driver
//
//  Created by Tom Bredemeier on 1/5/22.
//

import SwiftUI

struct PeriodView: View {
    let periods = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th"]
    var body: some View {
        NavigationView {
            VStack {
                ForEach(periods, id: \.self) { period in
                    CustomNavigationView(period: period)
                }
            }
            .navigationBarTitle("Select a class period", displayMode: .inline)
        }
    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodView()
    }
}

struct CustomNavigationView: View {
    var period: String
    var body: some View {
        NavigationLink("\(period) Period") {
            NameDisplayView(period: period)
        }
        .font(.title)
        .padding()
    }
}


