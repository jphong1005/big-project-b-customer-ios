//
//  ContentView.swift
//  AppleMarket
//
//  Created by 진태영 on 2022/12/27.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabSelection: Int = 1
    @State private var isShowingSheet: Bool = false
    @EnvironmentObject var userInfoStore: UserInfoStore
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var catalogueProductStore: CatalogueProductStore
    @EnvironmentObject var productStore: ProductStore
    
    var body: some View {
            TabView(selection: $tabSelection) {
                NavigationStack {
                    MainView()
                    
                }
                    .tabItem {
                        Image(systemName: "macbook.and.iphone")
                        Text("쇼핑하기")
                    }
                    .tag(1)
                
                NavigationStack {
                    SearchView()
                }
                .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("검색")
                    }
                    .tag(2)
                
                NavigationStack {
                    if userInfoStore.state == .signedIn {
                        CartSignInView()
                    } else {
                        CartSignOutView()
                    }
                }
                    .tabItem {
                        Image(systemName: "bag")
                        Text("장바구니")
                    }
                    .tag(3)
                
                NavigationStack {
                    MypageView()
                }
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("마이페이지")
                    }
                    .tag(4)
                    
            }
            .task {
                // 이전 로그인 기록이 있다면 자동 로그인
                if let email = UserDefaults.standard.string(forKey: UserDefaults.Keys.email.rawValue) {
                    if let password = UserDefaults.standard.string(forKey: UserDefaults.Keys.password.rawValue) {
                        userInfoStore.emailAuthSignIn(email: email, password: password)
                    }
                }
                
                /// 여기서는 Main Thread에서 실행됨
                await productStore.fetchProduct()
                await catalogueProductStore.fetchCatalogueProduct()
                if userInfoStore.userInfo != nil {
                    cartStore.fetchCart(uid: userInfoStore.userInfo?.userId ?? "")
                    orderStore.fetchOrderList(userId: userInfoStore.userInfo?.userId ?? "" )
                }
            }
            .onChange(of: userInfoStore.userInfo) { newValue in
                print("Onchange")
                if userInfoStore.userInfo != nil {
                    print("onChange userInfo fetch start")
                    cartStore.fetchCart(uid: userInfoStore.userInfo?.userId ?? "")
                    orderStore.fetchOrderList(userId: userInfoStore.userInfo?.userId ?? "" )
                }
            }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserInfoStore())
            .environmentObject(CatalogueProductStore())
            .environmentObject(CartStore())
    }
}
