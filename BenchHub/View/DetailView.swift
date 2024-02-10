//
//  DetailView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/05.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingSheet = false
    var selectedMapInfo: MapModel
    
    var body: some View {
        VStack() {
            HStack {
                Text(selectedMapInfo.name)
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            
            ScrollView(showsIndicators: false) {
                Divider()
                
                ReviewAndDistanceView()
                
                Divider()
                
                ImagesView(mapInfo: selectedMapInfo)
                
                CommentView(mapInfo: selectedMapInfo)
                
                Button("\(Image(systemName: "square.and.pencil")) レビューを書く") {
                    isShowingSheet = true
                }
                .sheet(isPresented: $isShowingSheet){
                    VStack {
                        HStack {
                            Button(action: {
                                isShowingSheet = false
                            }, label: {
                                Text("キャンセル")
                                    .foregroundColor(.accentColor)
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                isShowingSheet = false
                            }, label: {
                                Text("完了")
                                    .foregroundColor(.accentColor)
                            })
                        }
                        .padding()
                        
                        PostReviewView()
                        
                        Spacer()
                    }
                    .presentationDetents([.height(300)])
                    .presentationBackground(Color.background)
                }
                .padding()
            }
        }
        .padding()
    }
}

struct PostReviewView: View {
    var body: some View {
        
        VStack {
            HStack {
                Text("居心地")
                    .padding(.leading)
                
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
            
            Divider()
                .padding([.horizontal])

                HStack {
                    Button("\(Image(systemName: "camera.fill"))あなたの写真を追加"){
                        print("tap")
                    }
                    .foregroundColor(.accentColor)
                    Spacer()
                }
                .padding()
                
                Divider()
                    .padding([.horizontal])
                
                HStack {
                    Text("\(Image(systemName: "text.bubble"))あなたの口コミを追加")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                .cornerRadius(10)
                .onTapGesture {
                    print("tap")
                }
                .padding()
        }
        .frame(width: 350)
        .background(Color.component)
        .cornerRadius(10)
        .padding()
    }
}


struct ReviewAndDistanceView: View {
    @State private var isShowingSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text("10件の評価") // \(totalReviewCount)の評価
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.orange)
                    
                    Text("78%")
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
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
    var mapInfo: MapModel
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack {
                ForEach(1...3, id: \.self) { _ in
                    Image(mapInfo.ImageName)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 200,height: 280)
                }
            }
        }
    }
}

struct CommentView: View {
    var mapInfo: MapModel
    // さらに表示を追加する
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
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
                    .background(Color.component)
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    DetailView(selectedMapInfo: MockData.sampleEnpty)
}

