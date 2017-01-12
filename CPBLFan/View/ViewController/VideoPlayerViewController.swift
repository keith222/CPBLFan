//
//  VideoPlayerViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/4.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate{

    @IBOutlet weak var videoPlayView: YTPlayerView!
    var videoId: String!
    var isPresented: Bool = true
    var navigation: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set custom navigation bar
        self.navigation = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
        self.navigation.alpha = 0.7
        navigation?.tintColor = UIColor.darkBlue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss(_:)))
        navigation?.items = [self.navigationItem]
        self.view.addSubview(navigation!)
        
        // play video with youtube iframe player
        self.videoPlayView.load(withVideoId: self.videoId)
        self.videoPlayView.setPlaybackQuality(.auto)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation{
        case .landscapeLeft, .landscapeRight:
            self.navigation.frame.size = CGSize(width: self.view.bounds.size.width, height: 35)
        case .portrait:
            self.navigation.frame.size = CGSize(width: self.view.bounds.size.width, height: 64)
        default:
            break
        }
    }

    func dismiss(_ sender: AnyObject? = nil) {
        self.isPresented = false
        self.dismiss(animated: true) {}
    }

}
