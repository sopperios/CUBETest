//
//  AttractionsViewController.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit
import GoogleMaps

class AttractionsViewController: UIViewController {
    
    @IBOutlet weak var attractionImageViewHegihtConstraintMultiplier50: NSLayoutConstraint!
    @IBOutlet weak var googleMapHegithConstraintMultiplier50: NSLayoutConstraint!
    @IBOutlet weak var attractionImageViewHegihtConstraintMultiplier90: NSLayoutConstraint!
    @IBOutlet weak var googleMapHegithConstraintMultiplier90: NSLayoutConstraint!
    @IBOutlet weak var googleMapView: UIView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var webSite: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var businessHours: UILabel!
    @IBOutlet weak var attractionImageView: UIImageView!
    @IBOutlet weak var imagePageLable: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var images: [UIImage] = []
    private var attraction: Attraction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func setAttraction(attraction: Attraction) {
        self.attraction = attraction
    }
    
    @objc private func didChangeOrientation() {
        switch UIDevice.current.orientation {
        case .portrait:
            self.attractionImageViewHegihtConstraintMultiplier90.priority = UILayoutPriority(997)
            self.googleMapHegithConstraintMultiplier90.priority = UILayoutPriority(997)
            self.attractionImageViewHegihtConstraintMultiplier50.priority = UILayoutPriority(998)
            self.googleMapHegithConstraintMultiplier50.priority = UILayoutPriority(998)
        case .landscapeLeft, .landscapeRight:
            self.attractionImageViewHegihtConstraintMultiplier90.priority = UILayoutPriority(998)
            self.googleMapHegithConstraintMultiplier90.priority = UILayoutPriority(998)
            self.attractionImageViewHegihtConstraintMultiplier50.priority = UILayoutPriority(997)
            self.googleMapHegithConstraintMultiplier50.priority = UILayoutPriority(997)
        default:
            print("Other")
        }
    }
    
    private func setView() {
        self.didChangeOrientation()
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        let webSiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(webSiteTap(_:)))
        self.webSite.addGestureRecognizer(webSiteTapGesture)
        self.webSite.isUserInteractionEnabled = true
        guard let attraction = self.attraction else { return }
        self.attractionImageView.layer.cornerRadius = 6
        self.navigationItem.title = attraction.name
        self.content.text = attraction.introduction
        self.webSite.text = attraction.url
        self.phone.text = attraction.tel
        self.address.text = attraction.address
        self.businessHours.text = attraction.open_time
        self.images = []
        let dispatchGroup = DispatchGroup()
        attraction.images.forEach { item in
            if let url = URL(string: item.src) {
                dispatchGroup.enter()
                self.loadImage(from: url) {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            if self.images.count > 0 {
                self.pageControl.isHidden = false
                self.imagePageLable.isHidden = false
                self.attractionImageView.isHidden = false
            }
            self.attractionImageView.image = self.images.first
            self.pageControl.numberOfPages = self.images.count
            self.setImagePageLable()
        }
        // 設定google 地圖
        let camera = GMSCameraPosition.camera(withLatitude: attraction.nlat, longitude: attraction.elong, zoom: 15.0)
        let mapView = GMSMapView(frame: self.googleMapView.bounds)
        mapView.settings.scrollGestures = false
        mapView.camera = camera
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: attraction.nlat, longitude: attraction.elong)
        marker.title = attraction.name
        marker.snippet = attraction.address
        marker.map = mapView
        mapView.layer.cornerRadius = 6
        self.googleMapView.addSubview(mapView)
        self.googleMapView.layer.cornerRadius = 6
    }
    
    private func loadImage(from url: URL, completion: @escaping () -> Void) {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            if let image = UIImage(data: cachedResponse.data) {
                self.images.append(image)
                completion()
                return
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { completion() }
            guard let data = data, error == nil, let response = response else {
                print("Error loading image: \(String(describing: error))")
                return
            }
            if let image = UIImage(data: data) {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                DispatchQueue.main.async {
                    self.images.append(image)
                }
            }
        }
        task.resume()
    }
    
    private func setImagePageLable() {
        self.imagePageLable.text = "("+"\(self.pageControl.currentPage +  1)/\(self.pageControl.numberOfPages)"+")"
    }
    
    @objc private func webSiteTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, let attraction = self.attraction else { return }
        let sb = UIStoryboard(name: "WebViewController", bundle: nil)
        guard let webVC = sb.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        webVC.setTitleAndUrl(title: attraction.name, url: attraction.url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @IBAction func imageViewRightSwipe(_ sender: Any) {
        if self.pageControl.currentPage - 1 >= 0 {
            self.attractionImageView.image = self.images[self.pageControl.currentPage - 1]
            self.pageControl.currentPage -= 1
        } else {
            self.pageControl.currentPage = self.images.count
            self.attractionImageView.image = self.images.last
        }
        self.setImagePageLable()
    }
    
    @IBAction func imageViewLeftSwipe(_ sender: Any) {
        if self.pageControl.currentPage + 1 < self.images.count {
            self.attractionImageView.image = self.images[self.pageControl.currentPage + 1]
            self.pageControl.currentPage += 1
        } else {
            self.pageControl.currentPage = 0
            self.attractionImageView.image = self.images.first
        }
        self.setImagePageLable()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        self.attractionImageView.image = self.images[sender.currentPage]
        self.setImagePageLable()
    }
}
