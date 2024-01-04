//
//  MapVIew.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/01/04.
//
import SwiftUI
import MapKit

enum MapType {
    case standard // 標準
    case satellite // 衛生写真
    case hybrid // 衛生写真+交通機関ラベル
}

struct MapView: View {
    // 検索ワード
    let searchKey: String
    // マップ種類
    let mapType: MapType
    
    // キーワードから取得した緯度経度
    @State var targetCoordinate = CLLocationCoordinate2D()
    // 表示するマップの位置
    @State var cameraPosition: MapCameraPosition = .automatic 
    // 表示するマップのスタイル
    var mapStyle: MapStyle {
        switch mapType {
        case .standard:
            return MapStyle.standard()
        case .satellite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }
    
    var body: some View {
        Map(position: $cameraPosition){
            // マップにピンを表示
            //Marker(searchKey, coordinate:  targetCoordinate)
        }
        // マップのスタイルを反映
        .mapStyle(mapStyle)
        // 検索ワードの変更を検知
        .onChange(of: searchKey, initial: true) { oldValue, newValue in
            // 入力されたキーワードをデバッグに表示
            print("検索ワード: \(newValue)")
            
            // 地図の検索クエリの作成
            let request  = MKLocalSearch.Request()
            // 検索クエリにキーワードの設定
            request.naturalLanguageQuery = newValue
            // MLLocalSearchの初期化
            let search = MKLocalSearch(request: request)
            
            // 検索の開始
            search.start { response, error in
                // 結果が存在する時は1件目を取り出す
                if let mapItems = response?.mapItems,
                   
                   let mapItem = mapItems.first {
                    // 位置情報から緯度経度をtargetCoodinateに取り出す
                    targetCoordinate = mapItem.placemark.coordinate
                    
                    print("緯度経度: \(targetCoordinate)")
                    
                    // 表示するマップの領域を作成
                    cameraPosition = .region(MKCoordinateRegion(
                        center: targetCoordinate,
                        latitudinalMeters: 500.0,
                        longitudinalMeters: 500.0
                        
                    ))
                }
                
            }
        }
    }
}

#Preview {
    MapView(searchKey: "渋谷駅",mapType: .satellite)
}
