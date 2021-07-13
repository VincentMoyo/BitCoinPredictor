//
//  NewsCell.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/12.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with viewModel: NewsTableCellViewControllerModel){
        headingLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtile
        if let data = viewModel.imageData {
            newsImage.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - News Table Model
class NewsTableCellViewControllerModel {
    let title: String
    let subtile: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtile: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtile = subtile
        self.imageURL = imageURL
    }
}
