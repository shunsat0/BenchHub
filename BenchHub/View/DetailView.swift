//
//  DetailView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/05.
//


import SwiftUI
import PhotosUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isShowPostSheet: Bool
    var selectedMapInfo: MapModel
    @StateObject var viewModel = MapDataViewModel()
    @StateObject var detailViewModel = DetailViewModel()
    @StateObject var post = PostViewModel()
    @State private var evaluation: Int = 2
    @State private var text: String = ""
    @Binding var isPostReview: Bool
    @Binding var isShowReviewSheet: Bool
    @State var selectedImage: UIImage?
    @State var imageUrl: String?
    @State var isGoodOrBad: Bool
    @State var showAlert = false
    @Binding var getedData: Bool
    @Binding var isPostCompleted: Bool
    @State var isShowImagePicker: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(selectedMapInfo.name)
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            
            ScrollView(showsIndicators: false) {
                Divider()
                
                ImagesView(mapInfo: selectedMapInfo)
                    .padding(.top)
                
                CommentView(mapInfo: selectedMapInfo)
                    .padding(.top)
                
                Button("\(Image(systemName: "square.and.pencil")) レビューを書く") {
                    isShowPostSheet = true
                }
                .fullScreenCover(isPresented: $isShowPostSheet) {                    
                    ZStack {
                        VStack {
                            HStack {
                                Button("キャンセル") {
                                    isShowPostSheet = false
                                    isShowImagePicker = false
                                }
                                
                                Spacer()
                                
                                Button("送信") {
                                    detailViewModel.isTapped = true
                                    getedData = true
                                    // 評価 or コメントテキストが空ならアラート表示
                                    if (!isGoodOrBad || text.isEmpty) {
                                        showAlert = true
                                    } else {
                                        detailViewModel.isProgress = true
                                        Task {
                                            imageUrl = await post.uploadImage(name: selectedMapInfo.name, image: selectedImage)
                                            print("URL表示　\(String(describing: imageUrl))")
                                            
                                            await post.addData(postData: PostModel(id: selectedMapInfo.name, evaluation: evaluation, description: text, imageUrl: imageUrl))
                                            
                                            try await Task.sleep(nanoseconds: 5_000_000_000)
                                            
                                            detailViewModel.isProgress = false
                                            getedData = false
                                            isPostCompleted.toggle()
                                        }
                                    }
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("評価とコメントの両方を入力してください！"),
                                        dismissButton: .default(
                                            Text("OK"),
                                            action: {
                                                showAlert = false
                                                getedData = false
                                                print("ブール\(getedData)")
                                            }
                                        )
                                    )
                                }
                            }
                            .padding()
                            
                            PostReviewView(isShowImagePicker: $isShowImagePicker, evaluation: $evaluation, text: $text, selectedMapInfo: selectedMapInfo, selectedImage: $selectedImage, isGoodOrBad: $isGoodOrBad, detailViewModel: detailViewModel)
                            
                            Spacer()
                        }
                        .presentationDetents([.height(500)])
                        .presentationBackground(Color.background)
                        
                        if (detailViewModel.isProgress) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black.opacity(0.5))
                                .edgesIgnoringSafeArea(.all)
                        }
                        
                        if(isPostCompleted) {
                            ZStack {
                                VStack {
                                    Text("投稿完了しました👏")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    Button(action: {
                                        dismiss()
                                        isPostCompleted = false
                                    }) {
                                        Text("閉じる")
                                            .frame(width: 200, height: 50)
                                    }
                                    .accentColor(Color.white)
                                    .background(Color.blue)
                                    .cornerRadius(10.0)
                                    
                                }
                                
                                
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 12, height: 12)
                                    .modifier(ParticlesModifier())
                                    .offset(x: -100, y : -50)
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                    .modifier(ParticlesModifier())
                                    .offset(x: 60, y : 70)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.black)
                            .edgesIgnoringSafeArea(.all)
                        }
                    }
                }
            }
            .padding(16)
        }
        .padding(.bottom, -50)
    }
}

struct ImagesView: View {
    var mapInfo: MapModel
    @State var showImageList: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(mapInfo.reviews, id: \.id) { images in
                    if let imageUrl = URL(string: images.ImageUrl) {
                        // imageUrlがnilでない場合に実行
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                                .cornerRadius(10.0)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 250, height: 250)
                        }
                        .onTapGesture {
                            print("画像タップ")
                            showImageList = true
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showImageList) {
            ImagesListView(mapInfo: mapInfo, showImageList: $showImageList)
        }
    }
}



struct ImagesListView: View {
    var mapInfo: MapModel
    @Binding var showImageList: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(mapInfo.reviews, id: \.self) { image in
                        if let url = URL(string: image.ImageUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10.0)
                            }
                        placeholder: {
                            ProgressView()
                        }
                        .onTapGesture {
                            // Tap action here
                        }
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.top,50)
            .padding(.horizontal,10)
            
            
            HStack() {
                Button("\(Image(systemName: "xmark.circle.fill"))") {
                    showImageList = false
                }
                .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
        }
        
    }
}



struct CommentView: View {
    var mapInfo: MapModel
    private let lineLimit: Int = 4
    @State private var isExpanded = false
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(mapInfo.reviews, id: \.id) { review in
                    VStack(alignment: .leading) {
                        HStack {
                            if review.evaluation == 0 {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.orange)
                            } else {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                            Text(dateToString(review.date))
                        }
                        .padding([.leading, .trailing, .top])
                        
                        Text(review.description)
                            .lineLimit(isExpanded ? nil : lineLimit)
                            .fixedSize(horizontal: false, vertical: isExpanded)
                            .frame(maxWidth: 300, alignment: .leading)
                        
                        Button {
                            withAnimation { isExpanded.toggle() }
                        } label: {
                            
                            //TODO: 治す
                            Text(isExpanded ? "一部を表示" : "もっと見る")
                                .fontWeight(.regular)
                        }
                        .frame(minWidth:300, maxWidth: 300, alignment: .bottomTrailing)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .background(Color.component)
                    .cornerRadius(10)
                    .frame(height: isExpanded ? 250 : 150)
                }
            }
        }
    }
}
