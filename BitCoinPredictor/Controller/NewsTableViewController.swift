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
    lazy private var viewModels = [NewsTableModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.News.kCellNibName, bundle: nil),
                           forCellReuseIdentifier: Constants.News.kIdentifier)
        newsAPI.getTopHeadlines(q: Constants.News.kHeadline) { [weak self] result in
            switch result {
            case .success(let headlines):
                if headlines.isEmpty {
                    DispatchQueue.main.async {
                        let message = "There are no news for the current subject: \(Constants.News.kHeadline)"
                        self?.showUserErrorMessageDidInitiate(message)
                    }
                } else {
                    self?.articles = headlines
                    self?.viewModels = headlines.compactMap({
                        NewsTableModel(
                            newsList: NewsList(title: $0.title,
                                               subtile: $0.articleDescription ?? "No Description",
                                               imageURL: $0.urlToImage)
                        )
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let message = "Something went wrong in trying to retrieve the news: \(error)"
                    self?.showUserErrorMessageDidInitiate(message)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.News.kIdentifier, for: indexPath)
                as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
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
    
    func showUserErrorMessageDidInitiate(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
