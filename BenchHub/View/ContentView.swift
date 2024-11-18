//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/04.
//

import SwiftUI
import MapKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var mapDataViewModel = MapDataViewModel()
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
    
    @State var isPostCompleted:Bool = false

    
    var body: some View {
        
        ZStack() {
                MapReader {  proxy in
                    Map(position: $cameraPosition) {
                        UserAnnotation(anchor: .center)
                        ForEach(mapDataViewModel.mapData) { mapInfo in
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
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
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
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            HStack {
                                                Spacer()
                                                Button("閉じる") {
                                                    UIApplication.shared.endEditing()
                                                }
                                                Spacer().frame(width: 16)
                                            }
                                        }
                                    }
                                
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
                        }}
                    
                    .padding(.horizontal)
                }
            
            
            VStack {
                HStack {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gear")
                            .padding(12)
                            .background(Color.background, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .onAppear {
                        Task {
                            await mapDataViewModel.fetchData()
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        showSearchSheet = false
                    })
                    
                    Spacer()
                }
                .padding()
                .offset(y: -12)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowReviewSheet,onDismiss: {
            showSearchSheet = true
        }) {
            DetailView(isShowPostSheet: false, selectedMapInfo: detailViewModel.selectedFramework!, isPostReview: $isPost,isShowReviewSheet: $isShowReviewSheet, isGoodOrBad: false, getedData: $getedData, isPostCompleted: $isPostCompleted)
                .presentationDetents([ .medium, .large])
                .presentationBackground(Color.background)
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
                await mapDataViewModel.fetchData()
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
                await mapDataViewModel.fetchData()
            }
        } // Map
    }
} // ZStack

#Preview {
    ContentView(isPost: false)
}
