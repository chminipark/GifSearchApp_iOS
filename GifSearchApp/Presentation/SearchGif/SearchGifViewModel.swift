//
//  SearchGifViewModel.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/26.
//

import Foundation
import UIKit
import SDWebImage

enum Section: Int, CaseIterable {
    case main
}

enum ViewState {
    case idle
    case isLoding
}

class SearchGifViewModel {
    private lazy var provider: Provider = ProviderImpl()
    private lazy var imageCache = ImageCache(provider: provider)
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Gif>!
    var viewState: ViewState = .idle
    var currentPage = Page()
    var searchString: String = ""
    
    private let decoder = SDImageAWebPCoder.shared
    
    func paginationGif() {
        guard viewState == .idle,
              searchString != ""
        else {
            return
        }
        fetchGifInfos()
    }
    
    func searchGif(with gifName: String) {
        guard viewState == .idle,
              gifName != ""
        else {
            return
        }
        searchString = gifName
        currentPage = Page()
        fetchGifInfos()
    }
}

extension SearchGifViewModel {
    func fetchGifInfos() {
        let gifSearchRequestDTO = GifSearchRequestDTO(gifName: searchString, offset: currentPage.offset)
        let endpoint = APIEndpoints.getGifSearchInfo(with: gifSearchRequestDTO)
        
        viewState = .isLoding
        provider.request(with: endpoint) { [weak self] result in
            guard let _self = self else {
                return
            }
            
            _self.viewState = .idle
            
            switch result {
            case .success(let data):
                _self.currentPage = data.toDomainPage()
                print(_self.currentPage.offset)
                let gifInfos = data.toDomainGif()
                var snapshot = _self.dataSource.snapshot()
                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.main])
                }
                snapshot.appendItems(gifInfos, toSection: .main)
                // main or global???
                DispatchQueue.global(qos: .background).async {
                    _self.dataSource.apply(snapshot)
                }
            case .failure(let error):
                print("😡😡😡😡")
                print(error)
            }
        }
    }
    
    func downloadGif(_ gif: Gif) {
        imageCache.loadData(for: gif) { [weak self] item, gifData in
            guard let _self = self else {
                return
            }
            
            guard let gifData = gifData,
                  let gifObject = item as? Gif,
                  gifObject.image != gifData
            else {
                return
            }
            
            gifObject.image = gifData
            
            var snapshot = _self.dataSource.snapshot()
            if snapshot.indexOfItem(gifObject) == nil {
                return
            }
            snapshot.reloadItems([gifObject])
            DispatchQueue.global(qos: .background).async {
                _self.dataSource.apply(snapshot)
            }
        }
    }
}
