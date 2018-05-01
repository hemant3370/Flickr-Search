//
//  NibLoading.swift
//  Quiz
//
//  Created by Hemant Singh on 21/03/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNibs(nibNames nibs: [String]) {
        for nib in nibs {
            let cellNib = UINib(nibName: nib, bundle: nil)
            register(cellNib, forCellReuseIdentifier: nib)
        }
    }
}
extension UICollectionView {
    func registerNibs(nibNames nibs: [String]) {
        for nib in nibs {
            let cellNib = UINib(nibName: nib, bundle: nil)
            register(cellNib, forCellWithReuseIdentifier: nib)
        }
    }
}
