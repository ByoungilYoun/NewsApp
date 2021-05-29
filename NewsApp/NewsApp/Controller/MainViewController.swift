//
//  MainViewController.swift
//  NewsApp
//
//  Created by 윤병일 on 2021/05/28.
//

import UIKit
import SafariServices

class MainViewController : UIViewController {
  
  //MARK: - Properties
  private let tableView = UITableView()
  
  private var articles = [Article]()
  private var viewModels = [NewsTableViewCellViewModel]()
  
  private let searchVC = UISearchController(searchResultsController: nil)
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavi()
    setTableView()
    getTopStoriesFromApi()
    createSearchBar()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  //MARK: - Functions
  private func setNavi() {
    view.backgroundColor = .white
    title = "News"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    view.addSubview(tableView)
  }
  
  private func createSearchBar() {
    navigationItem.searchController = searchVC
    searchVC.searchBar.delegate = self
  }
  
  private func getTopStoriesFromApi() {
    APICaller.shared.getTopStories { [weak self] result in
      switch result {
      case .success(let articles) :
        self?.articles = articles
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
    let viewModel = articles[indexPath.row]
    
    guard let url = URL(string: viewModel.url ?? "") else {
      return
    }
    
    let vc = SFSafariViewController(url: url)
    present(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}

  //MARK: - UISearchBarDelegate
extension MainViewController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text, !text.isEmpty else { return }
    
    APICaller.shared.search(with: text) { [weak self] result in
      switch result {
      case .success(let articles) :
        self?.articles = articles
        self?.viewModels = articles.compactMap({
          NewsTableViewCellViewModel(title: $0.title ?? "", subtitle: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? ""))
        })
        
        DispatchQueue.main.async {
          self?.tableView.reloadData()
          self?.searchVC.dismiss(animated: true, completion: nil)
        }
        
        break
      case .failure(let error) :
        print(error)
      }
  }
}
}
