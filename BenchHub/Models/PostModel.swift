//
//  PostModel.swift
//  BenchHub
//
//  Created by Shun Sato on 2023/12/31.
//

import Foundation
import CoreLocation

struct Post: Identifiable, Codable {
    var id: String
    var name: String
    var address: String
    var vacantTime: String
    var smokingInfo: String
    var benchCount: String
    var comfortable: String
    var comment: String
    var coordinates: String
    var image: String

    var locationCoordinate: CLLocationCoordinate2D {
        let coordinatesArray = coordinates.split(separator: ",").map { Double($0) }
        return CLLocationCoordinate2D(
            latitude: coordinatesArray[0] ?? 0.0,
            longitude: coordinatesArray[1] ?? 0.0
        )
    }
}
