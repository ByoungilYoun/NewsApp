//
//  NewsTableViewCellViewModel.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/29.
//

import UIKit

class NewsTableViewCellViewModel {
  let title : String
  let subtitle : String
  let imageURL : URL?
  var imageData : Data? = nil
  
  init(title : String, subtitle : String, imageURL : URL?) {
    self.title = title
    self.subtitle = subtitle
    self.imageURL = imageURL
  }
}
