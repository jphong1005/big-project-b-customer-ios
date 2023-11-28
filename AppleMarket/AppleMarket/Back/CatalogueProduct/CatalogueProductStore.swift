//
//  CaltalogueProductStore.swift
//  AppleMarket
//
//  Created by 홍진표 on 2022/12/28.
//

import Foundation
import FirebaseFirestore

@MainActor
final class CatalogueProductStore: ObservableObject {
    
    // MARK: - Stored-Property (= Publisher)
    @Published var catalogueProducts: Array<CatalogueProduct> = Array<CatalogueProduct>()
    
    // MARK: - Local Variable
    let database: Firestore = Firestore.firestore()
    
    // MARK: - Fetch Catalogue Product
    public func fetchCatalogueProduct() async -> Void {
        
        self.catalogueProducts.removeAll()
        
        /// Task의 우선순위 priority를 .background로 설정하여 네트워킹 작업이 Background Thread에서 작동되도록 구현
        Task(priority: .background) {
            do {
                let querySnapshot: QuerySnapshot = try await database.collection("CatalogueProduct").getDocuments()
                
                querySnapshot.documents.forEach { document in
                    let docData = document.data()
                    
                    let id: String = document.documentID
                    let productName: String = docData["productName"] as? String ?? ""
                    let device: [String] = docData["device"] as? [String] ?? []
                    let category: String = docData["category"] as? String ?? ""
                    let description: String = docData["description"] as? String ?? ""
                    let price: Int = docData["price"] as? Int ?? 0
                    let thumbnailImage: String = docData["thumbnailImage"] as? String ?? ""
                    let status: Int = docData["status"] as? Int ?? 0
                    let descriptionImages: [String]? = docData["descriptionImages"] as? [String] ?? []
                    let model: [String]? = docData["model"] as? [String] ?? []
                    let color: [String]? = docData["color"] as? [String] ?? []
                    let storage: [String]? = docData["storage"] as? [String] ?? []
                    let recommendedProduct: [String]? = docData["recommendedProduct"] as? [String] ?? []
                    let netWork: [String]? = docData["netWork"] as? [String] ?? []
                    let processor: [String]? = docData["processor"] as? [String] ?? []
                    let memory: [String]? = docData["memory"] as? [String] ?? []
                    
                    let catalogueProduct: CatalogueProduct = CatalogueProduct(id: id, productName: productName, device: device, category: category, description: description, price: price, thumbnailImage: thumbnailImage, status: status, descriptionImages: descriptionImages, model: model, color: color, storage: storage, recommendedProduct: recommendedProduct, netWork: netWork, processor: processor, memory: memory)
                    
                    self.catalogueProducts.append(catalogueProduct)
                }
            } catch {
                print("error: \(error.localizedDescription)")
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Catalogue Product
    public func addCatalogueProduct(catalogueProduct: CatalogueProduct) async -> Void {
        
        do {
            try await database.collection("CatalogueProduct").document(catalogueProduct.id)
                .setData([
                    "id" : catalogueProduct.id,
                    "productName" : catalogueProduct.productName,
                    "device" : catalogueProduct.device,
                    "category" : catalogueProduct.category,
                    "description" : catalogueProduct.description,
                    "price" : catalogueProduct.price,
                    "thumbnailImage" : catalogueProduct.thumbnailImage,
                    "status" : catalogueProduct.status,
                    "model" : catalogueProduct.model ?? "",
                    "descriptionImages" : catalogueProduct.descriptionImages ?? "",
                    "storage" : catalogueProduct.storage ?? [],
                    "color" : catalogueProduct.color ?? [],
                    "netWork" : catalogueProduct.netWork ?? [],
                    "processor" : catalogueProduct.processor ?? [],
                    "memory" : catalogueProduct.memory ?? [],
                ])
            
            await fetchCatalogueProduct()
        } catch {
            print("error: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
}
