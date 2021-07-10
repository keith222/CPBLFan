//
//  NewsViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/24.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Kanna

class NewsViewModel {
    
    private var news: [News] = []
    private var newsCellViewModels: [NewsCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?(newsCellViewModels)
        }
    }
    
    var numberOfCells: Int {
        return newsCellViewModels.count
    }
    
    var reloadTableViewClosure: (([NewsCellViewModel])->())?
    var errorHandleClosure: ((String?)->())?
    
    init(){
        self.fetchNews()
    }
    
    func fetchNews(from page: Int = 1) {
        let route = "\(APIService.CPBLSourceURL)/xmdoc?page=\(page)"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else{
                self?.errorHandleClosure?(nil)
                return
            }
            
            do {
                var news = [News]()
                let doc = try HTML(html: text, encoding: .utf8)
            
                for (_,node) in doc.css(".NewsList > .item").enumerated() {
                    let newsTitleNode = node.at_css(".title > a")
                    let newsTitle = newsTitleNode?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    let newsDate = node.at_css(".date")?.text ?? ""
                    let newsImageUrl = node.at_css(".img a")?["style"]?.replacingOccurrences(of: ".*?(h[^)]*)\\)", with: "$1", options: [.regularExpression]) ?? ""
                    let newsUrl = newsTitleNode?["href"]!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                    let newsElement: News = News(title: newsTitle, date: newsDate, imageUrl: newsImageUrl, newsUrl: newsUrl)
                    news.append(newsElement)
                }
                self?.news.append(contentsOf: news)
                self?.processFetched(news)
                
            } catch let error as NSError {
                self?.errorHandleClosure?(error.localizedDescription)
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    func getCellViewModels() -> [NewsCellViewModel] {
        return self.newsCellViewModels
    }

    func getNewsContentViewModel(with index: Int) -> NewsContentViewModel {
        return NewsContentViewModel(with: self.news[index])
    }
    
    private func getCellViewModel(with index: Int) -> NewsCellViewModel {
        return self.newsCellViewModels[index]
    }
    
    private func processFetched(_ news: [News]) {
        var viewModels = [NewsCellViewModel]()
        for news in news {
            viewModels.append(createCellViewModel(with: news))
        }
        self.newsCellViewModels.append(contentsOf: viewModels)
    }
    
    private func createCellViewModel(with news: News) -> NewsCellViewModel {
        let imageURL = news.imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let newsUrl = news.newsUrl?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let title = news.title
        let date = news.date
    
        return NewsCellViewModel(imageURL: imageURL, newsUrl: newsUrl, title: title, date: date)
    }
}
