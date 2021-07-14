//
//  NewsCell.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/12.
//

import UIKit
import Kingfisher

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
        newsImage.kf.setImage(with: viewModel.imageURL)
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
