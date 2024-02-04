//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/04.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map() {
            ForEach(MockData.mapData) { location in
                Annotation(location.name, coordinate: location.coordinate) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.orange)
                        Text("🪑")
                            .padding(5)
                    }
                    .onTapGesture {
                        // sheet表示
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}
