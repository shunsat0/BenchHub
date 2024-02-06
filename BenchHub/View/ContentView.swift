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
    @StateObject var detailViewModel = DetailViewModel()
        
    @State var position: MapCameraPosition = .automatic
    @State var isShowSheet: Bool = false
    
    var body: some View {
        Map() {
            ForEach(viewModel.mapData) { mapInfo in
                Annotation(mapInfo.name, coordinate: mapInfo.coordinate) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.orange)
                        Text("🪑")
                            .padding(5)
                    }
                    .onTapGesture {
                        detailViewModel.selectedFramework = mapInfo
                        isShowSheet = true
                    }
                    .sheet(isPresented: $isShowSheet, content: {
                        DetailView(mapInfo: detailViewModel.selectedFramework!)
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
