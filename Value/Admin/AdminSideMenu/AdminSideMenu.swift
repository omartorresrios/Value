//
//  AdminSideMenu.swift
//  Value
//
//  Created by Omar Torres on 12/7/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

class Metric: NSObject {
    let name: MetricName
    
    init(name: MetricName) {
        self.name = name
    }
    
}

enum MetricName: String {
    case metric1 = "metric 1"
    case metric2 = "metric 2"
    case metric3 = "metric 3"
    case metric4 = "metric 4"
    case metric5 = "metric 5"
    case metric6 = "metric 6"
}

class AdminSideMenu: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    let cellId = "CellId"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    func showSideMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: window.frame.width - 50, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func dismissElements(metric: Metric?, isFromCell: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            }
            if isFromCell {
                self.adminMainController?.showControllerforMetric(metric: metric!)
            }
            
        }, completion: nil)
    }
    
    @objc func handleDismiss() {
        dismissElements(metric: nil, isFromCell: false)
    }
    
    func goToMetricView(metric: Metric) {
        dismissElements(metric: metric, isFromCell: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metrics.count
    }
    
    let metrics: [Metric] = {
        return [Metric(name: .metric1), Metric(name: .metric2), Metric(name: .metric3), Metric(name: .metric4), Metric(name: .metric5), Metric(name: .metric6)]
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AdminSideMenuCell
        
        let metric = metrics[indexPath.item]
        cell.metric = metric
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var adminMainController: AdminMainViewController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let metric = metrics[indexPath.item]
        goToMetricView(metric: metric)
    }
    
    override init() {
        super.init()
        
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(AdminSideMenuCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
    
}
