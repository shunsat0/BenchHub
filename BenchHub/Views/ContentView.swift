//
//  ContentView.swift
//  BenchHub
//
//  Created by Shun Sato on 2023/12/29.
//

import SwiftUI

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var viewModel = MapViewModel()

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917), // 例: 東京の座標
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )), annotationItems: viewModel.posts) { post in
            MapMarker(coordinate: post.locationCoordinate)
        }
    }
}


#Preview {
    ContentView()
}
