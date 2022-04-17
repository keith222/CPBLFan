//
//  VideoViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/31.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire

class VideoViewModel{
    
    private var pageToken: String = ""
    private var route: String {
        return "\(APIService.YoutubeAPIURL)search?part=snippet&channelId=UCDt9GAqyRzc2e5BNxPrwZrw&maxResults=15&order=date&pageToken=\(pageToken)&key=\(APIService.YoutubeAPIKey)"
    }
    private var videoItems: [VideoItem] = []
    private var videoCellViewModels: [VideoCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?(videoCellViewModels)
        }
    }
    
    var numberOfCells: Int {
        return videoCellViewModels.count
    }
    
    var reloadTableViewClosure: (([VideoCellViewModel])->())?
    var errorHandleClosure: (()->())?
    
    init(){
        self.fetchVideos()
    }
        
    func fetchVideos(){
        APIService.request(.get, route: self.route, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }

            if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSONDecoder().decode(Video.self, from: dataFromString)
                    self?.pageToken = json.nextPageToken ?? ""
                    self?.videoItems.append(contentsOf: json.items ?? [])
                    self?.processFetched(json.items ?? [])
                    return
                    
                } catch(let error) {
                    self?.errorHandleClosure?()
                    os_log("Error: %s", error.localizedDescription)
                }
            }
            self?.errorHandleClosure?()
        })
    }
    
    func getCellViewModels() -> [VideoCellViewModel] {
        return self.videoCellViewModels
    }
    
    func getCellViewModel(at index: Int) -> VideoCellViewModel {
        return self.videoCellViewModels[index]
    }
    
    func getVideoPlayerViewModel(at index: Int) -> VideoPlayerViewModel {
        let videoId = VideoId(videoId: videoItems[index].id?.videoId)
        return VideoPlayerViewModel(with: videoId)
    }
    
    private func processFetched(_ videoItems: [VideoItem]) {
        var viewModels = [VideoCellViewModel]()
        for videoItem in videoItems {
            viewModels.append(createCellViewModel(with: videoItem))
        }
        self.videoCellViewModels.append(contentsOf: viewModels)
    }
    
    private func createCellViewModel(with item: VideoItem) -> VideoCellViewModel {
        return VideoCellViewModel(videoId: item.id?.videoId, title: item.snippet?.title, imageUrl: item.snippet?.thumbnails?.high.url, date: item.snippet?.publishedAt)
    }
}
