//
//  LanguageView.swift
//  CUBETest
//
//  Created by Mint on 2024/6/2.
//

import Foundation
import UIKit

struct Language: Codable {
    let text: String
    let value: String
    var isSelected: Bool
}


class LanguageView: UIView {
    @IBOutlet weak var tableView: UITableView!
    var cancel: (() -> Void)?
    var confirm: (() -> Void)?
    private var languageList: [Language] = [Language(text: "正體中文", value: "zh-tw",isSelected:false),
                                            Language(text: "簡體中文", value: "zh-cn",isSelected:false),
                                            Language(text: "英文", value: "en",isSelected:false),
                                            Language(text: "日文", value: "ja",isSelected:false),
                                            Language(text: "韓文", value: "ko",isSelected:false),
                                            Language(text: "西班牙文", value: "es",isSelected:false),
                                            Language(text: "印尼文", value: "id",isSelected:false),
                                            Language(text: "泰文", value: "th",isSelected:false),
                                            Language(text: "越南文", value: "vi",isSelected:false)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "LanguageView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        self.setView()
    }
    
    func setView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "LanguageTableViewCell")
        guard let value = UserDefaults.standard.string(forKey: "language"), let jsonData = value.data(using: .utf8),let language = try? JSONDecoder().decode(Language.self, from: jsonData) else{ return }
        for i in 0..<self.languageList.count {
            if self.languageList[i].value == language.value {
                self.languageList[i].isSelected = true
            } else {
                self.languageList[i].isSelected = false
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        cancel?()
    }
    
    @IBAction func confirm(_ sender: Any) {
        self.languageList.forEach { item in
            if item.isSelected {
                guard let jsonData = try? JSONEncoder().encode(item) else { return}
                let jsonString = String(data: jsonData, encoding: .utf8)
                UserDefaults.standard.set(jsonString, forKey: "language")
            }
        }
        cancel?()
    }
    
}

extension LanguageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as? LanguageTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }
        cell.setCell(language: self.languageList[indexPath.row])
        cell.clickCell = { language in
            guard let language = language else {return}
            for i in 0..<self.languageList.count {
                if self.languageList[i].value == language.value {
                    self.languageList[i].isSelected = true
                } else {
                    self.languageList[i].isSelected = false
                }
            }
            self.tableView.reloadData()
        }
        return cell
    }
}

extension LanguageView: UITableViewDelegate {
    
}
