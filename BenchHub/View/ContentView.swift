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
        ZStack {
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
                        .sheet(isPresented: $isShowSheet) {
                            DetailView(selectedMapInfo: detailViewModel.selectedFramework!)
                                .presentationDetents([ .medium, .large])
                                .presentationBackground(Color.background)
                            
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchData()
                }
            }
            
            Button {
                // 現在地に戻る
                
            }label: {
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width: 30.0,height: 30.0)
                    .padding(5)
                    .background(Color.component)
                    .cornerRadius(10)
            }
            .padding(.leading,300)
            .padding(.top,700)
        }
    }
}


#Preview {
    ContentView()
}
