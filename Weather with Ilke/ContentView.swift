//
//  ContentView.swift
//  Weather with Ilke
//
//  Created by Ilke Yucel on 13.08.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var input:String = ""
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $input)
            Text(input)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
