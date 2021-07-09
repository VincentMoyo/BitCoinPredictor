//
//  NewsViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/08.
//

import UIKit
import NewsAPISwift
import SafariServices

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let newsAPI = NewsAPI(apiKey: K.News.apiKey)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableCellViewController.self,
                       forCellReuseIdentifier: K.News.identifier)
        return table
    }()
    
    private var articles = [NewsArticle]()
    private var viewModels = [NewsTableCellViewControllerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        newsAPI.getTopHeadlines(q: K.News.headline) { [weak self] result in
            switch result {
            case .success(let headlines):
                self?.articles = headlines
                    self?.viewModels = headlines.compactMap({
                        NewsTableCellViewControllerModel(
                            title: $0.title,
                            subtile: $0.articleDescription ?? "No Description",
                            imageURL: $0.urlToImage
                        )
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: K.News.identifier,
            for: indexPath
        ) as? NewsTableCellViewController else {
            fatalError()
        }
        cell.backgroundColor = #colorLiteral(red: 0.6930736278, green: 0.8536937925, blue: 1, alpha: 1)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        let vc = SFSafariViewController(url: article.url)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
