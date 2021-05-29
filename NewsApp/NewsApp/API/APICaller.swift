//
//  APICaller.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/28.
//

import Foundation

final class APICaller {
  
  //MARK: - Properties
  static let shared = APICaller()
  
  struct Constants {
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=0fb3b9d37fd949fc8891ea58dedf4c8b")
    static let searchUrlString = "https://newsapi.org/v2/everything?.sortedBy=popularity&apiKey=0fb3b9d37fd949fc8891ea58dedf4c8b&q="
  }
  
  //MARK: - init
  private init () {
    
  }
  
  //MARK: - Functions
  public func getTopStories(completion : @escaping (Result<[Article], Error>) -> Void) {
    guard let url = Constants.topHeadlinesURL else {return}
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        completion(.failure(error))
      } else if let data = data {
        do {
          let result = try JSONDecoder().decode(APIResponse.self, from: data)
          
          completion(.success(result.articles))
        }
        catch {
          completion(.failure(error))
        }
      }
    }
    task.resume()
  }
  
  public func search(with query : String, completion : @escaping (Result<[Article], Error>) -> Void) {
    guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
    let urlString = Constants.searchUrlString + query
    
    guard let url = URL(string: urlString) else {return}
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        completion(.failure(error))
      } else if let data = data {
        do {
          let result = try JSONDecoder().decode(APIResponse.self, from: data)
          
          completion(.success(result.articles))
        }
        catch {
          completion(.failure(error))
        }
      }
    }
    task.resume()
  }

}
