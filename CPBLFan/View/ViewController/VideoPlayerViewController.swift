//
//  VideoPlayerViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/4.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD
import WebKit
import os

class VideoPlayerViewController: BaseViewController {

    @IBOutlet weak var videoWebView: WKWebView!
            
    var videoPlayerViewModel: VideoPlayerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setUp()
        self.bindViewModel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.updateConstraintsIfNeeded()
    }
        
    private func bindViewModel() {
        // play video with youtube iframe player
        if let htmlString = videoPlayerViewModel?.videoHtml {
            self.videoWebView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    private func setUp() {
        self.videoWebView.navigationDelegate = self
        self.videoWebView.isOpaque = false
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.videoPlayerViewModel?.isPresented = false
        self.dismiss(animated: true)
    }
}

extension VideoPlayerViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUD.hide(animated: true, completion: { [weak self] _ in
            self?.performAlert(with: error.localizedDescription)
            os_log("Error: %s", error.localizedDescription)
        })
    }
}
