//
//  MainMyProductView.swift
//  AppleMarket
//
//  Created by youngseo on 2022/12/27.
//

import SwiftUI

struct MyProduct : Identifiable{
    var id: Int
    let imagePath: String
    let productName: String
    let category: String
    let details: String
}

var myProducts: [MyProduct] = [
    MyProduct(id: 0, imagePath: "https://cdn.shopify.com/s/files/1/1684/4603/products/iphone-14-Pro-Max_Graphite_600x.png?v=1662809202", productName: "iPhone 14 Pro", category: "iPhone", details: "iPhone 14 Pro 256GB 스페이스 블랙"),
    MyProduct(id: 1, imagePath: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/mac-card-40-macbook-pro-13-202206?wid=1200&hei=1000&fmt=p-jpg&qlt=95&.v=1665082744007", productName: "MacBook Pro 13", category: "MacBook Pro", details: "13형 MacBook Pro - 스페이스그레이"),
    MyProduct(id: 2, imagePath: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/ipad-card-40-pro-202210?wid=680&hei=528&fmt=p-jpg&qlt=95&.v=1664578794100", productName: "iPad Pro", category: "iPad", details: "11형 iPad Pro Wi-Fi 128GB - 실버"),
    MyProduct(id: 3, imagePath: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/watch-card-40-se-202209_GEO_KR?wid=680&hei=528&fmt=png-alpha&.v=1661812053226", productName: "Apple Watch SE", category: "Apple Watch", details: "Apple Watch")
]

struct MainMyProductView: View {
    
    //    let selectedMyProduct: MyProduct
    @EnvironmentObject var userInfoStore: UserInfoStore
    @EnvironmentObject var catalogueProductStore: CatalogueProductStore
    @Binding var isShowingSheet: Bool
    @Binding var isShowingLoginSheet: Bool
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("내 기기에 맞는 액세서리 쇼핑하기")
                .fontWeight(.bold)
                .font(.system(size: 24))
                .padding(.leading)
            
            // 등록된 기기가 없을 때
            if ((userInfoStore.myDevices.isEmpty) == true) && userInfoStore.state == .signedIn {
                
                Button {
                    isShowingSheet.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 250)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .center){
                            Image(systemName: "plus.square.dashed")
                                .font(.system(size: 100))
                                .padding(.bottom, 15)
                            Text("등록된 기기가 없습니다.")
                        }
                        .foregroundColor(.gray)
                    }
                    
                }
                .sheet(isPresented: $isShowingSheet) {
                    AddMyDeviceView(isShowingSheet: $isShowingSheet)
                        .presentationDetents([.medium])
                }
            } else if userInfoStore.state == .signedOut {
                NavigationLink {
                    LoginView(isShowingLoginSheet: $isShowingLoginSheet)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 250)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .center){
                            Image(systemName: "plus.square.dashed")
                                .font(.system(size: 100))
                                .padding(.bottom, 15)
                            Text("등록된 기기가 없습니다.")
                        }
                        .foregroundColor(.gray)
                    }
                }
                
            }
            
            //등록된 기기가 있을 때
            else {
                TabView() {
                    ForEach(userInfoStore.myDevices , id: \.self) { product in
                        NavigationLink {
                            MyProductDetailView(myProducts: CatalogueProduct(id: "", productName: product.deviceName, device: [], category: "", description: "", price: 0, thumbnailImage: "", status: 0, descriptionImages: [product.deviceImage], model: [], color: [], storage: [], recommendedProduct: [], netWork: [], processor: [], memory: []))
                        } label: {
                          
                            VStack {
                                
                                // 기기 사진
                                AsyncImage(url: URL(string: product.deviceImage )) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 230, height: 300)
                                        .padding(.top, -30)
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(product.deviceDescription)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                    .padding(.top, -20)
                                Text(product.deviceName)
                                
                            }
                            .foregroundColor(.black)
                        }
                    }
                }
                .frame(width: 400, height: 300)
                .tabViewStyle(.page)
                .indexViewStyle(.page)
            }
        }
        .padding(.top, 50)
        
        }
    }
struct MainMyProductView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MainMyProductView(isShowingSheet: .constant(true), isShowingLoginSheet: .constant(true))
                .environmentObject(CatalogueProductStore())
        }
    }
}
