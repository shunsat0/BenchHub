//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/04.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = MapDataViewModel()
    @State var position: MapCameraPosition = .automatic
    @State var isShowSheet: Bool = false
    
    var body: some View {
        Map() {
            ForEach(viewModel.mapData) { location in
                Annotation(location.name, coordinate: location.coordinate) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.orange)
                        Text("🪑")
                            .padding(5)
                    }
                    .onTapGesture {
                        print(location.description)
                        isShowSheet = true
                    }
                    .sheet(isPresented: $isShowSheet, content: {
                        DetailView(mapInfo: location)
                    })
                }
            }
        }
        .onAppear {            
            Task {
                await viewModel.fetchData()
            }
        }
    }
}


#Preview {
    ContentView()
}
