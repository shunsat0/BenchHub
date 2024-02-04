//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2023/12/29.
//

//
//  ContentView.swift
//  MapMarkerSample
//
//  Created by yoshiyuki oshige on 2022/09/09.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // 指す座標の配列
    let spotlist = [
        Spot(lat: 35.6834843, long: 139.7644207),
        Spot(lat: 35.6790079, long: 139.7675881),
        Spot(lat: 35.6780057, long: 139.7631035)
    ]
    
    // 領域を指定する
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 35.6805702,   // 緯度
            longitude: 139.7676359  // 経度
        ),
        latitudinalMeters: 1000.0, // 南北距離
        longitudinalMeters: 1000.0  // 東西距離
    )
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: spotlist)
        { spot in
            MapMarker(coordinate: spot.coordinate,
                      tint: .blue)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
