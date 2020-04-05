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
    
    func fetchNews(from page: Int = 0) {
        let route = "\(APIService.CPBLSourceURL)/news/lists/news_lits.html?per_page=\(page)"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else{
                self?.errorHandleClosure?(nil)
                return
            }
            
            do {
                var news = [News]()
                let doc = try HTML(html: text, encoding: .utf8)
                
                let topNewsTitle = doc.at_css(".news_head_title > a")?.text ?? ""
                let topNewsDate = doc.at_css(".news_head_date")?.text ?? ""
                let topNewsImageUrl = doc.at_css(".games_news_pic > a > img")?["src"]?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                let topNewsUrl = doc.at_css(".games_news_pic > a")?["href"]?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                
                if !topNewsTitle.isEmpty {
                    let topNewsElemet: News = News(title: topNewsTitle, date: topNewsDate, imageUrl: topNewsImageUrl, newsUrl: topNewsUrl)
                    news.append(topNewsElemet)
                }
                
                for (_,node) in doc.css(".news_row").enumerated() {
                    guard node.at_css(".news_row_date")?.text! != nil else{continue}
                    
                    let newsTitle = node.at_css(".news_row_cont > div > a.news_row_title")?.text!.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    
                    var tempDate = node.at_css(".news_row_date")?.text!
                    let startIndex = tempDate?.index((tempDate?.startIndex)!, offsetBy: 6)
                    let endIndex = tempDate?.index((tempDate?.endIndex)!, offsetBy: -17)
                    tempDate = String(tempDate![startIndex!..<endIndex!])
                    let newsDate = tempDate?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    
                    let newsImageUrl = node.at_css(".news_row_pic > img")?["src"]!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                    let newsUrl = node.at_css(".news_row_cont > div > a")?["href"]!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
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
