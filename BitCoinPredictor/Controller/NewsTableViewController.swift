//
//  NewsTableViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/12.
//

import UIKit
import NewsAPISwift
import SafariServices

class NewsTableViewController: UITableViewController {
    
    private let newsAPI = NewsAPI(apiKey: Constants.News.kApiKey)
    lazy private var articles = [NewsArticle]()
    lazy private var viewModels = [Article]()
    private var initialErrorMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.News.kCellNibName, bundle: nil),
                           forCellReuseIdentifier: Constants.News.kIdentifier)
        newsAPI.getTopHeadlines(q: Constants.News.kHeadline) { [weak self] result in
            switch result {
            case .success(let headlines):
                if headlines.isEmpty {
                    DispatchQueue.main.async {
                        self!.errorMessage = NSLocalizedString("CURRENT_NEWS_NO_SUBJECT", comment: "") + "\(Constants.News.kHeadline)"
                        self?.showUserErrorMessageDidInitiate(self!.errorMessage)
                    }
                } else {
                    self?.articles = headlines
                    self?.viewModels = headlines.compactMap({
                        Article(
                            newsList: NewsArray(title: $0.title,
                                               subtile: $0.articleDescription ?? NSLocalizedString("NO_DESCRIPTION", comment: ""),
                                               imageURL: $0.urlToImage)
                        )
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self!.errorMessage =  NSLocalizedString("NEWS_API_ERROR", comment: "") + "\(error)"
                    self?.showUserErrorMessageDidInitiate(self!.errorMessage)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.News.kIdentifier, for: indexPath) as? NewsTableViewCell
        cell?.configure(with: viewModels[indexPath.row])
        
        return cell ?? NewsTableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        let vcc = SFSafariViewController(url: article.url)
        
        present(vcc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension NewsTableViewController {
    var errorMessage: String {
        get {
            return initialErrorMessage
        }
        set {
            initialErrorMessage = newValue
        }
    }
}
