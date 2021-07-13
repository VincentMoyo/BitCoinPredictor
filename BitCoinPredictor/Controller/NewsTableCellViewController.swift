//
//  NewsTableCellViewController.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/08.
//

import UIKit



class NewsTableCellViewController: UITableViewCell {
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    } ()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    } ()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: 70
        )
        subtitleLabel.frame = CGRect(x: 10,
                                     y: 70,
                                     width: contentView.frame.size.width - 170,
                                     height: contentView.frame.size.height/2
        )
        newsImageView .frame = CGRect(x: contentView.frame.size.width-160,
                                      y: 5,
                                      width: 140,
                                      height: contentView.frame.size.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableCellViewControllerModel){
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtile
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
