//
//  DetailView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/05.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    var selectedMapInfo: MapModel
    
    var body: some View {
        VStack {
            HStack {
                Text(selectedMapInfo.name)
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.primary)
                })
                .padding()
            }
            
struct ReviewAndDistanceView: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                // ここタップしてもsheet出て評価できる
                Text("10件の評価") // \(totalReviewCount)の評価
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                HStack {
                    
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.accentColor)
                    
                    Text("78%")
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("距離")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                HStack {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond")
                        .foregroundColor(.secondary)
                    Text("300m") // \(distance)m
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
        }
    }
}



struct ImagesView: View {
    var body: some View {
        TabView {
            ForEach(1...3, id: \.self) { _ in
                Image("bench")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct CommentView: View {
    var mapInfo: MapModel
    
    var body: some View {
        TabView {
            ForEach(mapInfo.reviews, id: \.id) { review in
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(review.title)
                            Spacer()
                            Text("1年前")
                        }
                        
                        
                        if(review.evaluation == 0){
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.orange)
                        }else {
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundColor(.orange)
                            
                        }
                    }
                    .padding([.leading,.trailing,.top])
                    
                    
                    
                    Text(review.description)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .padding()
                    
                    Spacer()
                }
                .frame(width: 350, height: 250)
                .background(.regularMaterial)
                .cornerRadius(20)
                
                
                
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

#Preview {
    DetailView(selectedMapInfo: MockData.sample)
}
