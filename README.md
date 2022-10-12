# GifSearchApp
- GIF 이미지 검색 앱
- [GIPHY API](https://developers.giphy.com/) 사용
- 이미지 캐싱 기능, `NSCache` 사용
- 무한 스크롤 기능, 두가지 모두 사용
    1. scrollViewDidScroll
    2. prefetchItemsAt     

#
## 고민한 점들
### 1. Entity Gif: struct -> Gif: class 변경

CollectionView를 업데이트 할때 diffiableDatasource를 사용했습니다.  
snapshot으로 보통 reloadItem 메소드로 collectionView를 업데이트 하는데  
reloadItem 호출시 object가 struct타입인지 class 타입인지에 따라 적용방식이 달랐습니다.  
struct는 값타입이라 identifier가 같은 새로운 object를 만들어야 하는 반면에 class는 참조타입이라  
단순히 기존 object 안에 있는 이미지 프로퍼티만 새로운 값으로 변경하고 reloadItem 메소드만 호출하면되서  
자원 및 코드 양이 줄었습니다.

### 2. Webp(Data) -> UIImage 변환하기 위해 외부 라이브러리 SDWebImage의 사용
외부 라이브러리는 안쓰려고 했는데 구글링 해본 결과 데이터 변환하는 과정을 만들려면 생각보다 시간이 많이 소요될 것 같아서 디코딩 과정만 외부 라이브러리를 사용하는 것으로 결정했습니다.

### 3. applyItem, reloadItem 분리
플젝에 없는 기존코드(dispatchgroup 사용)
```swift
func loadData() {
        dispatchGroup.enter()
        viewState = .isLoding
        
        fetchGifInfo(with: searchStrig, page: currentPage) { [weak self] gifs in
            guard let _self = self else {
                return
            }
            _self.dispatchGroup.enter()
            
            _self.applySnapshot(with: gifs) {
                gifs.forEach { gif in
                    
                    _self.dispatchGroup.enter()
                    
                    _self.downloadGif(gif.imageURL) { image in
                        gif.image = image
                        _self.reloadSnapshot(with: gif)
                        _self.dispatchGroup.leave()
                    }
                }
                _self.dispatchGroup.leave()
            }
            
            _self.dispatchGroup.leave()
            _self.dispatchGroup.notify(queue: .global(qos: .background)) {
                _self.viewState = .idle
            }
        }
    }
```
이미지를 받기 위해서는  
1. 각 이미지 데이터를 받을 수 있는 imageURL를 api로 호출하고
2. 각 imageURL으로 실제 데이터를 받아와야하는  

두번의 과정이 필요했습니다.  
2번 과정일떼 비동기로 데이터가 들어오다보니 순서에 맞게 코드를 실행시키고 싶어서 dispatchGroup을 사용했는데  
코드도 복잡하고 Cache기능을 사용하기 위해 applyItem부분과 reloadItem부분을 분리했습니다.

applyItem은 서치바에서 새롭게 검색할때, scrollViewDidScroll에서 새로운 데이터를 받아올때만 실행되고(1번과정) reloadItem은 cell에 Gif 객체가 들어오면 각 셀이 이미지 다운로드후 적용시키도록 변경했습니다.(2번과정)