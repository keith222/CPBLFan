//
//  VideoPlayerViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/2/2.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation

class VideoPlayerViewModel {
    
    private(set) var videoId: String?
    
    var videoHtml: String {
        return "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'><style>body{margin: 0;}</style></header><body><div style=''><iframe style='position:absolute;top:0;left:0;width:100%;height:100%' src='https://www.youtube.com/embed/\(self.videoId ?? "")?autoplay=1' frameborder='0' allow='accelerometer; encrypted-media;' allowfullscreen></iframe></div></body></html>"
    }
    var isPresented: Bool = true
    
    
    init(with videoId: VideoId?) {
        self.videoId = videoId?.videoId
    }
}

