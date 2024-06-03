//
//  HomeViewController.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var languageItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = HomeViewModel()
    private let languageView = UIView()
    private let newsMoreView = UIView()
    private let attractionsMoreView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.getValue()
        self.setView()
        
    }
    
    private func setView() {
        self.languageView.isHidden = true
        let view = LanguageView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cancel = {
            self.hideLanguageView()
            self.setLanguageItem()
            self.getValue()
        }
        self.languageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        self.languageView.translatesAutoresizingMaskIntoConstraints = false
        self.languageView.addSubview(view)
        self.view.addSubview(self.languageView)
        self.view.addSubview(self.newsMoreView)
        NSLayoutConstraint.activate([
            self.languageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.languageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.languageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.languageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            // 水平至中
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            // 設定寬度
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9),
            // 設定高度
            view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.7),
        ])
        self.setLanguageItem()
    }
    
    private func setLanguageItem() {
        // 設定語系按鈕
        guard let value = UserDefaults.standard.string(forKey: "language"), let jsonData = value.data(using: .utf8),let language = try? JSONDecoder().decode(Language.self, from: jsonData) else{ return }
        self.languageItem.image = nil
        self.languageItem.title = language.text
    }
    
    private func setTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeTableViewNewsCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewNewsCell")
        self.tableView.register(UINib(nibName: "HomeTableViewAttractionsCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewAttractionsCell")
    }
    
    private func getValue(){
        viewModel.fetchNews(page: 1) { [weak self] error in
            guard let err = error else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                return
            }
            print(err)
        }
        viewModel.fetchAttractions(page: 1) { [weak self] error in
            guard let err = error else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                return
            }
            print(err)
        }
    }
    
    @IBAction func languageAction(_ sender: Any) {
        self.showLanguageView()
    }
    
    private func showLanguageView() {
        self.languageView.isHidden = false
        self.languageView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.languageView.alpha = 1
        }
    }
    
    private func hideLanguageView() {
        self.languageView.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.languageView.alpha = 0
        }) { _ in
            
            self.languageView.isHidden = true
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 取消选中 cell
        switch indexPath.section {
        case 0:
            let sb = UIStoryboard(name: "WebViewController", bundle: nil)
            guard let webVC = sb.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
            webVC.setTitleAndUrl(title: "最新消息", url: self.viewModel.news[indexPath.row].url)
            self.navigationController?.pushViewController(webVC, animated: true)
        case 1:
            let sb = UIStoryboard(name: "AttractionsViewController", bundle: nil)
            guard let attractionVC = sb.instantiateViewController(withIdentifier: "AttractionsViewController") as? AttractionsViewController else {return}
            attractionVC.setAttraction(attraction: self.viewModel.attractions[indexPath.row])
            self.navigationController?.pushViewController(attractionVC, animated: true)
            
            //            if let url = URL(string: self.viewModel.attractions[indexPath.row].url) {
            //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //            }
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.viewModel.news.count > 3 ? 3 : self.viewModel.news.count
        case 1:
            return self.viewModel.attractions.count > 3 ? 3 : self.viewModel.attractions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewNewsCell", for: indexPath) as? HomeTableViewNewsCell else {
                fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
            }
            cell.setCell(new: self.viewModel.news[indexPath.row])
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewAttractionsCell", for: indexPath) as? HomeTableViewAttractionsCell else {
                fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
            }
            cell.setCell(attraction: self.viewModel.attractions[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return self.viewModel.news.count != 0 ? "最新消息" : nil
        case 1:
            return self.viewModel.attractions.count != 0 ? "遊憩景點" : nil
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let button = UIButton()
            button.setTitle("查看更多", for: .normal)
            button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
            button.setTitleColor(UIColor.systemGray3, for: .normal)
            self.newsMoreView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(greaterThanOrEqualTo: self.newsMoreView.leadingAnchor, constant: 12).isActive = true
            button.trailingAnchor.constraint(equalTo: self.newsMoreView.trailingAnchor, constant: -24).isActive = true
            button.topAnchor.constraint(equalTo: self.newsMoreView.topAnchor, constant: 12).isActive = true
            button.bottomAnchor.constraint(equalTo: self.newsMoreView.bottomAnchor, constant: -12).isActive = true
            button.addTarget(self, action: #selector(newsMoreClick), for: .touchUpInside)
            return self.viewModel.news.count > 3 ? self.newsMoreView: nil
        case 1:
            let button = UIButton()
            button.setTitle("查看更多", for: .normal)
            button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
            button.setTitleColor(UIColor.systemGray3, for: .normal)
            self.attractionsMoreView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(greaterThanOrEqualTo: self.attractionsMoreView.leadingAnchor, constant: 12).isActive = true
            button.trailingAnchor.constraint(equalTo: self.attractionsMoreView.trailingAnchor, constant: -24).isActive = true
            button.topAnchor.constraint(equalTo: self.attractionsMoreView.topAnchor, constant: 12).isActive = true
            button.bottomAnchor.constraint(equalTo: self.attractionsMoreView.bottomAnchor, constant: -12).isActive = true
            button.addTarget(self, action: #selector(attractionsMoreClick), for: .touchUpInside)
            return self.viewModel.attractions.count > 3 ? self.attractionsMoreView: nil
        default:
            return nil
        }
    }
    
    @objc private func newsMoreClick() {
        let sb = UIStoryboard(name: "MoreViewController", bundle: nil)
        guard let moreVC = sb.instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else {return}
        moreVC.setValue(object: self.viewModel.news)
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
    
    @objc private func attractionsMoreClick() {
        let sb = UIStoryboard(name: "MoreViewController", bundle: nil)
        guard let moreVC = sb.instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else {return}
        moreVC.setValue(object: self.viewModel.attractions)
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
    
    
}
