//
//  MoreViewController.swift
//  CUBETest
//
//  Created by Mint on 2024/6/2.
//

import UIKit

class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = HomeViewModel()
    private var attractions:[Attraction]?
    private var news:[New]?
    private var isLoadingData: Bool = false
    private var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView() 
    }
    
    private func setTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeTableViewNewsCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewNewsCell")
        self.tableView.register(UINib(nibName: "HomeTableViewAttractionsCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewAttractionsCell")
    }
    
    func setValue<T>(object: T) {
        if let news = object as? [New] {
            self.news = news
        }
        if let attractions = object as? [Attraction] {
            self.attractions = attractions
        }
    }
    
    private func getValue(){
        self.isLoadingData = true
        if let news = self.news {
            self.page += 1
            viewModel.fetchNews(page: page) { [weak self] error in
                guard let err = error else {
                    if let viewModelNews = self?.viewModel.news {
                        self?.news =  news + viewModelNews
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.isLoadingData = false
                    return
                }
                print(err)
            }
        }
        if let attractions = self.attractions {
            self.page += 1
            viewModel.fetchAttractions(page: page) { [weak self] error in
                guard let err = error else {
                    if let viewModelAttractions = self?.viewModel.attractions {
                        self?.attractions =  attractions + viewModelAttractions
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.isLoadingData = false
                    return
                }
                print(err)
            }
        }
    }

}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 取消选中 cell
        if let news = self.news {
            let sb = UIStoryboard(name: "WebViewController", bundle: nil)
            guard let webVC = sb.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
            webVC.setTitleAndUrl(title: "最新消息", url: news[indexPath.row].url)
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        if let attractions = self.attractions {
            let sb = UIStoryboard(name: "AttractionsViewController", bundle: nil)
            guard let attractionVC = sb.instantiateViewController(withIdentifier: "AttractionsViewController") as? AttractionsViewController else {return}
            attractionVC.setAttraction(attraction: attractions[indexPath.row])
            self.navigationController?.pushViewController(attractionVC, animated: true)
        }
    }
}

extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = self.news {
            return news.count
        }
        
        if let attractions = self.attractions {
            return attractions.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let news = self.news {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewNewsCell", for: indexPath) as? HomeTableViewNewsCell else {
                fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
            }
            cell.setCell(new: news[indexPath.row])
            return cell
        }
        
        if let attractions = self.attractions {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewAttractionsCell", for: indexPath) as? HomeTableViewAttractionsCell else {
                fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
            }
            cell.setCell(attraction: attractions[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                let screenHeight = scrollView.frame.size.height
                
                // 檢查是否滾動到了底部並且沒有在加載數據
                if offsetY > contentHeight - screenHeight && !isLoadingData {
                    getValue() // 加載更多數據
                }
    }
}

