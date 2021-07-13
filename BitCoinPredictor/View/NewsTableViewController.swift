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
    
    let newsAPI = NewsAPI(apiKey: K.News.apiKey)
    private var articles = [NewsArticle]()
    private var viewModels = [NewsTableCellViewControllerModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.News.cellNibName, bundle: nil), forCellReuseIdentifier: K.News.identifier)
        //tableView.register(NewsCell.self, forCellReuseIdentifier: K.News.identifier)
        newsAPI.getTopHeadlines(q: K.News.headline) { [weak self] result in
            switch result {
            case .success(let headlines):
                print("Yeses \(headlines.count)")
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("list size\(viewModels.count)")
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.News.identifier, for: indexPath) as? NewsCell else {
            fatalError()
        }
        cell.backgroundColor = #colorLiteral(red: 0.6930736278, green: 0.8536937925, blue: 1, alpha: 1)
        //let viewss = viewModels[indexPath.row]
        //cell.headingLabel.text = viewss.title
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]

        let vc = SFSafariViewController(url: article.url)
        present(vc, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
