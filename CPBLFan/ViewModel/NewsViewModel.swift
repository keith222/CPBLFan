//
//  NewsViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/24.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kanna
import ObjectMapper

class NewsViewModel{
    
    var imageURL: String?
    var newsUrl: String?
    var title: String?
    var date: String?

    init(){}
    
    init(data: News){
        self.imageURL = data.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        self.newsUrl = data.newsUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        self.title = data.title
        self.date = data.date
    }
    
    func fetchNews(from page: Int, handler: @escaping (([News])->())){
        let route = "\(APIService.CPBLSourceURL)/news/lists/news_lits.html?per_page=\(page)"
        APIService.request(.get, route: route, completionHandler: { text in
            var news: [News]? = []
            
            if let doc = HTML(html: text, encoding: .utf8){
                let topNewsTitle = doc.at_css(".news_head_title > a")?.text
                let topNewsDate = doc.at_css(".news_head_date")?.text
                let topNewsImageUrl = doc.at_css(".games_news_pic > a > img")?["src"]?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                let topNewsUrl = doc.at_css(".games_news_pic > a")?["href"]?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)

                if topNewsTitle != nil{
                    let topNewsElemet: News = News(JSON: ["title": topNewsTitle!, "date": topNewsDate!, "imageUrl": topNewsImageUrl, "newsUrl": topNewsUrl!])!
                    news?.append(topNewsElemet)
                }
                
                for (_,node) in doc.css(".news_row").enumerated(){
                    guard node.at_css(".news_row_date")?.text! != nil else{continue}
                    
                    let newsTitle = node.at_css(".news_row_cont > div > a.news_row_title")?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    var tempDate = node.at_css(".news_row_date")?.text!
                    let startIndex = tempDate?.index((tempDate?.startIndex)!, offsetBy: 6)
                    let endIndex = tempDate?.index((tempDate?.endIndex)!, offsetBy: -17)
                    tempDate = tempDate?.substring(with: (startIndex!..<endIndex!))
                    let newsDate = tempDate?.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let newsImageUrl = node.at_css(".news_row_pic > img")?["src"]!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                    let newsUrl = node.at_css(".news_row_cont > div > a")?["href"]!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                    let newsElement:News = News(JSON: ["title": newsTitle!, "date": newsDate!, "imageUrl": newsImageUrl, "newsUrl": newsUrl!])!
                    news?.append(newsElement)
                }
                
                handler(news!)
            }
        })
    }
    
    func fetchNewsContent(from route:String, handler: @escaping ((String)->())){
        APIService.request(.get, route: route, completionHandler: { text in
            if let doc = HTML(html: text, encoding: .utf8){
                var content = doc.at_css(".cont_txt_line_height")?.text!
                content = content?.replacingOccurrences(of: "\r\n\t\t\t\t", with: "")
                handler(content!)
            }
        })
    }
}
