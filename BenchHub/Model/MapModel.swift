//
//  MapModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/04.
//

import Foundation
import MapKit

struct MapModel:Identifiable{
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    let name: String
    let ImageName: String
    let description: String
}

//struct MockData {
//    static let sample = MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",ImageName: "bench",description: "ホームレースがよく日光を浴びています。夕方になると、キッズたちが元気よく遊んでいます。")
//    
//    static let mapData = [
//        MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",ImageName: "bench",description: "ホームレースがよく日光を浴びています。夕方になると、キッズたちが元気よく遊んでいます。"),
//        MapModel(latitude: 35.562362, longitude: 139.715177, name: "蒲田駅西口", ImageName: "bench",description: "交番の前の広場にアルミ製のベンチがあります。足を乗せていると、おじさんに注意されます。")
//    ]
//}
