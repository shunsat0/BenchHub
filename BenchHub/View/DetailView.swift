//
//  DetailView.swift
//  BenchHub
//
//  Created by Shun Sato on 2024/02/05.
//


import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isShowPostSheet:Bool
    var selectedMapInfo: MapModel
    @StateObject var viewModel = MapDataViewModel()
    @StateObject var post = PostViewModel()
    
    @State private var evaluation: Int = 2
    @State private var text: String = ""
    
    @Binding var isPostReview: Bool
    @Binding var isShowReviewSheet: Bool
    @State var selectedImage:  UIImage?
    
    @State var imageUrl:String?
    
    @State var isGoodOrBad: Bool
    @State var showAlert = false
    
    @Binding var getedData: Bool
    
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
                
                ReviewAndDistanceView(isShowPostSheet: isShowPostSheet) {
                    isShowPostSheet = true
                }
                
                Divider()
                
                ImagesView(mapInfo: selectedMapInfo)
                    .padding(.top)
                
                CommentView(mapInfo: selectedMapInfo)
                    .padding(.top)
                
                Button("\(Image(systemName: "square.and.pencil")) レビューを書く") {
                    isShowPostSheet = true
                }
                .sheet(isPresented: $isShowPostSheet){
                    VStack {
                        HStack {
                            Button("キャンセル"){
                                isShowPostSheet = false
                            }
                            
                            Spacer()
                            
                            Button("完了") {
                                getedData = true
                                print("ブール\(getedData)")
                                // 評価 or コメントテキストが空あらアラート表示
                                if(!isGoodOrBad || text.isEmpty) {
                                    showAlert = true
                                    print("評価が空です")
                                    print(showAlert)
                                }else {
                                    Task {
                                        imageUrl = await post.uploadImage(name: selectedMapInfo.name, image: selectedImage)
                                        print("URL表示　\(String(describing: imageUrl))")
                                        
                                        await post.addData(postData: PostModel(id: selectedMapInfo.name, evaluation: evaluation, description: text, imageUrl: imageUrl))
                                        
                                        isShowReviewSheet = false
                                        isShowPostSheet = false
                                        getedData = false
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
                        
                        PostReviewView(evaluation: $evaluation, text: $text, selectedMapInfo: selectedMapInfo,selectedImage: $selectedImage,isGoodOrBad: $isGoodOrBad)
                        
                        Spacer()
                    }
                    .presentationDetents([.height(500)])
                    .presentationBackground(Color.background)
                }
                .padding()
            }
        }
        .padding()
    }
}

struct PostReviewView: View {
    @State var isPressedThumbsUp: Bool = false
    @State var isPressedThumbsDown: Bool = false
    @State private var isShowSheet: Bool = false
    @State private var isShowImagePicker: Bool = false
    @Binding var evaluation: Int
    @Binding var text: String
    var selectedMapInfo: MapModel
    var post = PostViewModel()
    @Binding var selectedImage: UIImage?
    @Binding var isGoodOrBad: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Text("居心地")
                    .padding(.leading)
                
                Spacer()
                
                Group {
                    Button(action: {
                        isPressedThumbsUp.toggle()
                        if isPressedThumbsUp {
                            isPressedThumbsDown = false
                        }
                        
                        isGoodOrBad = isPressedThumbsUp // ボタンが押されているかどうかの判別
                        
                        evaluation = 0 // good
                        
                    }, label: {
                        Image(systemName: "hand.thumbsup.circle.fill")
                            .foregroundColor(isPressedThumbsUp ? .accentColor : .secondary)
                    })
                    
                    Button(action: {
                        isPressedThumbsDown.toggle()
                        if isPressedThumbsDown {
                            isPressedThumbsUp = false
                        }
                        
                        isGoodOrBad = isPressedThumbsDown // ボタンが押されているかどうかの判別
                        
                        evaluation = 1 // bad
                    }, label: {
                        Image(systemName: "hand.thumbsdown.circle.fill")
                            .foregroundColor(isPressedThumbsDown ? .accentColor : .secondary)
                    })
                }
                .foregroundColor(.secondary)
                .imageScale(.large)
            }
            .padding()
            
            Divider()
                .padding([.horizontal])
            
            HStack {
                VStack {
                    TextEditor(text: $text)
                        .textEditorStyle(PlainTextEditorStyle())
                        .frame(height: 80)
                        .keyboardType(.twitter)
                        .font(.body)
                        .background(Color.background)
                        .cornerRadius(10.0)
                }
                Spacer()
            }
            .padding()
            
            HStack {
                VStack {
                    Button("\(Image(systemName: "camera.fill"))あなたの写真を追加"){
                        isShowImagePicker = true
                    }
                    .foregroundColor(.accentColor)
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            
            Divider()
                .padding([.horizontal])
            
        }
        .frame(width: 350)
        .background(Color.component)
        .cornerRadius(10)
        .padding()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



struct ReviewAndDistanceView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isShowPostSheet:Bool
    var postButtonAction: () -> Void
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text("10件の評価") // \(totalReviewCount)の評価
                    .foregroundColor(.secondary)
                    .font(.caption)
                Button(action: {
                    postButtonAction()
                }, label: {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.accentColor)
                        
                        Text("78%")
                            .fontDesign(.monospaced)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                })
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
            LazyHStack(spacing: 16) {
                ForEach(mapInfo.reviews, id: \.id) { images in
                    if let imageUrl = URL(string: images.ImageUrl) {
                        // imageUrlがnilでない場合に実行
                        AsyncImage(url: imageUrl) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10.0)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 250, height: 250)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}



struct CommentView: View {
    var mapInfo: MapModel
    private let lineLimit: Int = 4
    @State private var isExpanded = false
    
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
                            Text("1年前")
                        }
                        .padding([.leading, .trailing, .top])
                        
                        Text(review.description)
                            .lineLimit(isExpanded ? nil : lineLimit)
                            .fixedSize(horizontal: false, vertical: isExpanded)
                            .frame(maxWidth: 300, alignment: .leading)
                        
                        Button {
                            withAnimation { isExpanded.toggle() }
                        } label: {
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

//#Preview {
//    DetailView(isShowPostSheet: false, selectedMapInfo: sample, isPostReview: .constant(false), isShowReviewSheet: .constant(false),isGoodOrBad: false)
//}

var sample = MapModel(latitude: 35.561282, longitude: 139.711039, name: "西蒲田公園",reviews: [Review(description: "公園のベンチは非常に快適で、座り心地が良いです。木陰に配置されており、景色を楽しみながらくつろげます。メンテナンスも行き届いており、清潔感があります。公園を訪れる人々にとって、素晴らしい休憩スポットとなっています。", evaluation: 0, ImageUrl: "https://1.bp.blogspot.com/-ezrLFVDoMhg/Xlyf7yQWzaI/AAAAAAABXrA/utIBXYJDiPYJ4hMzRXrZSHrcZ11sW2PiACNcBGAsYHQ/s1600/no_image_yoko.jpg"),Review(description: "公園のベンチは老朽化しており、座面が不安定です。背もたれもないため、長時間座っていると疲れやすく、くつろぐことができません。また、周囲にゴミや汚れが散乱しており、清潔さを欠いています。公園全体のメンテナンスが行き届いていない印象を受けます。", evaluation: 1, ImageUrl: "https://1.bp.blogspot.com/-ezrLFVDoMhg/Xlyf7yQWzaI/AAAAAAABXrA/utIBXYJDiPYJ4hMzRXrZSHrcZ11sW2PiACNcBGAsYHQ/s1600/no_image_yoko.jpg")] )

