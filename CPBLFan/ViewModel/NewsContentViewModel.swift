//
//  NewsContentViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/1/27.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Kanna

class NewsContentViewModel {
    
    private let news: News
    
    var fontChanged: Bool = false
    
    var route: String {
        return "\(APIService.CPBLSourceURL)\(self.news.newsUrl ?? "")"
    }
    
    var title: String {
        return self.news.title ?? ""
    }
    
    var date: String {
        return self.news.date ?? ""
    }
    
    var imageUrl: String {
        return self.news.imageUrl ?? ""
    }
    
    var newsContent: String = "" {
        didSet {
            self.loadNewsContent?(self.newsContent)
        }
    }
    
    var loadNewsContent: ((String)->())?

    init(with news: News) {
        self.news = news
        self.fetchNewsContent()
    }
    
    private func fetchNewsContent(){
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else { return }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                let content = doc.at_css(".cont_txt_line_height")?.text ?? ""
                self?.newsContent = content.replacingOccurrences(of: "\r\n\t\t\t\t", with: "")
                
            } catch let error as NSError{
               os_log("Error: %s", error.localizedDescription)
            }
        })
    }
}
