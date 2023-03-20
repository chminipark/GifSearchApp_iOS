# GifSearchApp
- GIF 이미지 검색 앱

## ScreenShot
![GifSearchAppScreenShot](https://user-images.githubusercontent.com/77793412/226292256-4f0ec039-23dc-46ea-9710-b22607125a58.gif)

## Introduction
- [GIPHY API](https://developers.giphy.com/) 사용
- 이미지 캐싱 기능, `NSCache` 사용
- `UICollectionViewFlowLayout` 사용하여 UI 레이아웃 구성
- `DiffableDataSource` 사용하여 콜렉션 뷰 데이터 관리
- 무한 스크롤 기능, 두가지 모두 사용
    1. scrollViewDidScroll
    2. prefetchItemsAt