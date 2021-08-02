//
//  ContentView.swift
//  Currencies
//
//  Created by Manal El Ouardani on 1/8/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
                .navigationTitle("Currency Exchange")
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
