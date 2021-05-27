//
//  APIResponse.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/28.
//

import Foundation

struct APIResponse : Codable {
  let articles : [Article]
}

struct Article : Codable {
  let source : Source
  let title : String?
  let description : String?
  let url : String?
  let urlToImage : String?
  let publishedAt : String?
}

struct Source : Codable {
  let name : String
}
