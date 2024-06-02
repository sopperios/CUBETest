//
//  HomeTableViewAttractionsCell.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit

class HomeTableViewAttractionsCell: UITableViewCell {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var attractionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(attraction: Attraction) {
        self.attractionImageView.image = nil
        self.title.text = attraction.name
        self.subTitle.text = attraction.name
        if let image = attraction.images.first, let url = URL(string:image.src) {
            self.loadImage(from: url)
        }
        self.content.text = attraction.introduction
        
    }
    
    func loadImage(from url: URL) {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            if let image = UIImage(data: cachedResponse.data) {
                self.attractionImageView.image = image
                return
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, let response = response else {
                print("Error loading image: \(String(describing: error))")
                return
            }
            if let image = UIImage(data: data) {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                
                DispatchQueue.main.async {
                    self.attractionImageView.image = image
                }
            }
        }
        task.resume()
    }
    
}
