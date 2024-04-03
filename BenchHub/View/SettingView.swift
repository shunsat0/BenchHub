//
//  HelloView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/03/13.
//

import SwiftUI
import MapKit

struct SettingMenue: Identifiable, Hashable {
    let name: String
    let icon: String
    let id = UUID()
}

private var settings = [
    SettingMenue(name: "よくある質問",icon: "questionmark.circle"),
    SettingMenue(name: "利用規約",icon: "doc.plaintext"),
    SettingMenue(name: "プライバシーポリシー",icon: "hand.raised")
]


struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section(header: Text("通知")){
                NavigationLink(
                    destination: EmptyView(),
                    label: {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.accentColor)
                            Text("通知設定")
                        }
                    }
                    
                )
            }
            Section(header: Text("その他")){
                ForEach(settings) { setting in
                    NavigationLink(
                        destination:  EmptyView(),
                        label: {
                            HStack {
                                Image(systemName: setting.icon)
                                    .foregroundColor(.accentColor)
                                Text(setting.name)
                            }
                        }
                    )
                    
                }
            }
            Section(header: Text("口コミ")){
                NavigationLink(
                    destination: PostBenchInfoView(),
                    label: {
                        HStack {
                            Image(systemName: "chair")
                                .foregroundColor(.accentColor)
                            Text("ベンチ情報を追加")
                        }
                    }
                )
            }
        }
    }
}

struct PostBenchInfoView: View {
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var placeName:String = ""
    @State private var coordinate: CLLocationCoordinate2D = .init(latitude: 0.00,
                                                                  longitude: 0.00)
    let locationManager = CLLocationManager()
    
    var body: some View {
        ZStack {
            VStack {
                List{
                    Section(header: Text("口コミ")){
                        MapReader{proxy in
                            Map(position: $position)
                                .frame(width: 300,height: 200)
                                .cornerRadius(10.0)
                                .task {
                                    let manager = CLLocationManager()
                                    manager.requestWhenInUseAuthorization()
                                }
//                                .onTapGesture { position in
//                                    Marker(coordinate: coordinate, label: Text("test"))
//                                    if let selectedCoordinate = proxy.convert(position, from: .local) {
//                                        coordinate = selectedCoordinate
//                                    }
//                                }
                        }
                    }
                    TextField(text: $placeName, prompt: Text("場所名")) {
                        Text("placeName")
                    }
                    
                    Text("latitude: \(coordinate.latitude)")
                    Text("longitude: \(coordinate.longitude)")
                }
            }
        }
    }
}

#Preview {
    //SettingView()
    PostBenchInfoView()
}
