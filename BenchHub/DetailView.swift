//
//  DetailView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/05.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var mapInfo: MapModel
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Button(action: {
                    dismiss()
                    // isShowSheetをfalseにするには、やっぱViewModel必要かな
                }, label: {
                    Text("閉じる")
                })
                .padding()
            }
            
            Spacer()
            
            Text(mapInfo.name)
                .font(.largeTitle)
            
            Image("bench")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 150)
            
            Text(mapInfo.description)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailView(mapInfo: MockData.sample)
}
