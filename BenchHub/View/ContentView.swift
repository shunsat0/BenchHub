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
    @State var showSearchSheet: Bool = true
    @State var inputText: String = ""
    @State var searchText: String = ""
    
    @State var targetCoordinate = CLLocationCoordinate2D()
    @State var cameraPosition: MapCameraPosition = .automatic
    
    @State var showSttings = false
    
    @State private var coordinate: CLLocationCoordinate2D = .init(latitude: 0.00,
                                                                  longitude: 0.00)
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationView {
                MapReader {  proxy in
                    Map(position: $cameraPosition) {
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
                                    showSearchSheet = false
                                }
                                .sheet(isPresented: $isShowReviewSheet,onDismiss: {
                                    showSearchSheet = true
                                }) {
                                    DetailView(isShowPostSheet: false, selectedMapInfo: detailViewModel.selectedFramework!, isPostReview: $isPost,isShowReviewSheet: $isShowReviewSheet, isGoodOrBad: false, getedData: $getedData)
                                        .presentationDetents([ .medium, .large])
                                        .presentationBackground(Color.background)
                                }
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    // 設定ボタン
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gear")
                            .padding()
                            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 10)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        // 検索バーを閉じる
                        showSearchSheet = false
                    })
                    .padding(.bottom,120)
                    .padding(.trailing,300)
                    
                    VStack {
                        ZStack {
                            // 背景
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThickMaterial)
                                .shadow(radius: 10)
                                .frame(height: 50)
                            
                            HStack(spacing: 6) {
                                Spacer()
                                    .frame(width: 0)
                                
                                // 虫眼鏡
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                // テキストフィールド
                                TextField("場所を入力して移動", text: $inputText)
                                    .onSubmit {
                                        searchText = inputText
                                        inputText = ""
                                    }
                                    .submitLabel(.search)
                                
                                // 検索文字が空ではない場合は、クリアボタンを表示
                                if !inputText.isEmpty {
                                    Button {
                                        inputText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                        .padding(.horizontal)
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
            .onChange(of: searchText, initial: true) { oldValue, newValue in
                print("検索ワード: \(newValue)")
                let request  = MKLocalSearch.Request()
                request.naturalLanguageQuery = newValue
                
                let search = MKLocalSearch(request: request)
                search.start { response, error in
                    if let mapItems = response?.mapItems,
                       let mapItem = mapItems.first {
                        targetCoordinate = mapItem.placemark.coordinate
                        print("緯度経度: \(targetCoordinate)")
                        print(mapItems)
                        cameraPosition = .region(MKCoordinateRegion(
                            center: targetCoordinate,
                            latitudinalMeters: 500.0,
                            longitudinalMeters: 500.0
                            
                        ))
                    }
                }
            }
            .onAppear() {
                showSearchSheet = true
                cameraPosition = position
                Task {
                    await viewModel.fetchData()
                }
            } // Map
        }
    } // ZStack
}

#Preview {
    ContentView(isPost: false)
}
