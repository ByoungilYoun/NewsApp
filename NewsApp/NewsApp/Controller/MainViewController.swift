//
//  MainViewController.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/28.
//

import UIKit

class MainViewController : UIViewController {
  
  //MARK: - Properties
  private let tableView = UITableView()
  
  private var viewModels = [NewsTableViewCellViewModel]()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavi()
    setTableView()
    getTopStoriesFromApi()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  //MARK: - Functions
  private func setNavi() {
    view.backgroundColor = .white
    title = "News"
  }
  
  private func setTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    view.addSubview(tableView)
  }
  
  private func getTopStoriesFromApi() {
    APICaller.shared.getTopStories { [weak self] result in
      switch result {
      case .success(let articles) :
        self?.viewModels = articles.compactMap({
          NewsTableViewCellViewModel(title: $0.title ?? "", subtitle: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? ""))
        })
        
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
        
        break
      case .failure(let error) :
        print(error)
      }
    }
  }
}

  //MARK: - UITableViewDataSource
extension MainViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { fatalError() }
    cell.configure(with: viewModels[indexPath.row])
    return cell
  }
}

  //MARK: - UITableViewDelegate
extension MainViewController : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}
