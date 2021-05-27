//
//  MainViewController.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/28.
//

import UIKit

class MainViewController : UIViewController {
  
  //MARK: - Properties
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavi()
    getTopStoriesFromApi()
  }
  //MARK: - Functions
  private func setNavi() {
    view.backgroundColor = .white
    title = "News"
  }
  
  private func getTopStoriesFromApi() {
    APICaller.shared.getTopStories { result in
      switch result {
      case .success(let response) :
        break
      case .failure(let error) :
        print(error)
      }
    }
  }
}
