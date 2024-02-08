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
            
            ScrollView {
                Divider()
                
                ReviewAndDistanceView()
                
                Divider()
                
                PostReviewView()
                
                ImagesView()
                    .frame(minHeight: 200)
                
                CommentView(mapInfo: selectedMapInfo)
                    .frame(minHeight: 300)
            }
        }
        .padding()
    }
}

struct PostReviewView: View {
    var body: some View {
        HStack {
            Text("この場所を評価")
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
        }
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("全般")
                    
                    Text("10件の評価") // \(totalReviewCount)の評価
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
                
                Group {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "hand.thumbsup.circle.fill")
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "hand.thumbsdown.circle.fill")
                    })
                }
                .foregroundColor(.secondary)
                .imageScale(.large)
            }
            .padding()
            
        }
        .frame(width: 350, height: 50)
        .background(.regularMaterial)
        .cornerRadius(10)
    }
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
                    .frame(width: 200,height: 150)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct CommentView: View {
    var mapInfo: MapModel
    
    // さらに表示を追加する
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
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
                    .frame(width: 350, height: 180)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    DetailView(selectedMapInfo: MockData.sample)
}
