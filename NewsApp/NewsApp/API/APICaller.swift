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
}
