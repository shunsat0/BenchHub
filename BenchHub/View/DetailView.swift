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
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("閉じる")
                })
                .padding()
            }
            
            Spacer()
            
            Text(selectedMapInfo.name)
                .font(.largeTitle)
            
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
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > mapInfo.reviews[0].rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
    
    var body: some View {
        TabView {
            ForEach(mapInfo.reviews, id: \.id) { review in
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.title)
                        Spacer()
                        Text("1年前")
                    }
                    .padding([.horizontal,.top])
                    
                    HStack {
                        if label.isEmpty == false {
                            Text(label)
                        }
                        
                        ForEach(1..<maximumRating + 1, id: \.self) { number in
                            image(for: number)
                                .foregroundStyle(number > review.rating ? offColor : onColor)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
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
