//
//  LanguageTableViewCell.swift
//  CUBETest
//
//  Created by Mint on 2024/6/2.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    private var language: Language?
    var clickCell: ((Language?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setView() {
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTap(_:)))
        self.addGestureRecognizer(cellTapGesture)
        self.isUserInteractionEnabled = true
       
        self.itemView.layer.shadowOffset = CGSizeMake(0, 0)
        self.itemView.layer.shadowOpacity = 0.1
        self.itemView.layer.cornerRadius = 6
    }
    
    func setCell(language: Language) {
        self.language = language
        self.titleLabel.text = language.text
        if language.isSelected {
            self.itemView.backgroundColor = UIColor.languargeViewCellSelectedMode
        } else {
            self.itemView.backgroundColor = UIColor.languargeViewCellMode
        }
    }
    
    @objc private func cellTap(_ sender: UITapGestureRecognizer) {
        self.language?.isSelected = true
        clickCell?(self.language)
    }
    
}
