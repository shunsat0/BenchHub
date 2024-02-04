//
//  SpotModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/01/10.
//

import Foundation
import MapKit
// スポットの構造体
struct Spot: Identifiable {
    let id = UUID()
    let lat: Double
    let long: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
