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
                    // アイコンに変える
                    Text("閉じる")
                })
                .padding()
            }
            
            
            
            Spacer()
            
            ImagesView()
            
            Spacer()
            
            CommentView(mapInfo: selectedMapInfo)
            
            Spacer()
        }
        .padding()
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
