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
    let reviews: [Review]
}

struct Review: Identifiable,Hashable {
    let id = UUID()
    let description: String
    let evaluation: Int
    let title: String
}


struct MockData {
    static let sample = MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",ImageName: "bench", reviews: [Review(description: "公園のベンチは非常に快適で、座り心地が良いです。木陰に配置されており、景色を楽しみながらくつろげます。メンテナンスも行き届いており、清潔感があります。公園を訪れる人々にとって、素晴らしい休憩スポットとなっています。", evaluation: 0,title: "良い！"),Review(description: "公園のベンチは老朽化しており、座面が不安定です。背もたれもないため、長時間座っていると疲れやすく、くつろぐことができません。また、周囲にゴミや汚れが散乱しており、清潔さを欠いています。公園全体のメンテナンスが行き届いていない印象を受けます。", evaluation: 1,title: "悪い！")] )
    
    static let sampleEnpty = MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",ImageName: "", reviews: [])
}
