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
    @StateObject var postViewModel = PostViewModel()
    
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var isShowReviewSheet: Bool = false
    @State var isPost: Bool =  false
    @State var getedData:Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation(anchor: .center)
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
                            isShowReviewSheet = true
                        }
                        .sheet(isPresented: $isShowReviewSheet) {
                            DetailView(isShowPostSheet: false, selectedMapInfo: detailViewModel.selectedFramework!, isPostReview: $isPost,isShowReviewSheet: $isShowReviewSheet, isGoodOrBad: false, getedData: $getedData)
                                .presentationDetents([ .medium, .large])
                                .presentationBackground(Color.background)
                        }
                    }
                }
            }
            .task {
                let manager = CLLocationManager()
                manager.requestWhenInUseAuthorization()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .onChange(of: getedData) {
                Task {
                   await viewModel.fetchData()
                }
            }
            .onAppear() {
                Task {
                    await viewModel.fetchData()
                }
            }
        }
    }
}


#Preview {
    ContentView(isPost: false)
}
