//
//  HomeTableViewNewsCell.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit

class HomeTableViewNewsCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(new:New) {
        self.title.text = new.title
        self.content.text = new.description
    }
    
}
