//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/04.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    var body: some View {
        Map() {
            ForEach(MockData.mapData) { location in
                Marker(location.name, coordinate: location.coordinate)
                    .tint(.blue)
            } 
        }
    }
}

#Preview {
    ContentView()
}
