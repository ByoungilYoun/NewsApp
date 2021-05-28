//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/29.
//

import UIKit

class NewsTableViewCell : UITableViewCell {
  
  //MARK: - Properties
  static let identifier = "NewsTableViewCell"
  
  private let newsTitleLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 25, weight: .medium)
    return label
  }()
  
  private let subtitleLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.numberOfLines = 0
    return label
  }()
  
  private let newsImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  //MARK: - init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
    subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
    newsImageView.frame = CGRect(x: contentView.frame.size.width - 150, y: 5, width: 160, height: contentView.frame.size.height - 10)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    newsTitleLabel.text = nil
    subtitleLabel.text = nil
    newsImageView.image = nil
  }
  //MARK: - Functions
  func setUI() {
    [newsTitleLabel, newsImageView, subtitleLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func configure(with viewModel : NewsTableViewCellViewModel) {
    newsTitleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    
    if let data = viewModel.imageData {
      newsImageView.image = UIImage(data: data)
    } else if let url = viewModel.imageURL {
      // fetch image
      URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data, error == nil else {
          return
        }
        viewModel.imageData = data
        DispatchQueue.main.async {
          self.newsImageView.image = UIImage(data: data)
        }
      }.resume()
    }
  }
}
