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
                }, label: {
                    Text("閉じる")
                })
                .padding()
            }
            
            Spacer()
            
//            Text(mapInfo.name)
//                .font(.largeTitle)
            Text("公園")
                .font(.largeTitle)
            
            TabView {
                ForEach(1...3, id: \.self) { _ in
                    Image("bench")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.black, lineWidth: 0.5)
//                        )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Spacer()
            
            TabView {
                ForEach(1...3, id: \.self) { _ in
                    
                    VStack {
                        HStack {
                            Text("無題")
                            Spacer()
                            Text("1年前")
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("★★★★⭐︎")
                                .foregroundStyle(.orange)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Text("サンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキスト")
                            .font(.body)
                            .foregroundStyle(.primary)
                        .padding()
                    }
                    .frame(width: 350, height: 250)
                    .background(.regularMaterial)
                    .cornerRadius(20)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailView(mapInfo: MockData.sample)
}
