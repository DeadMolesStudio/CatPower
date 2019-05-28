//
// Created by Danil on 2019-05-28.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit

class HistoryView: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.Id)
        setup()
    }
    func setup() {
        self.collectionView.backgroundColor = .white
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.Id, for: indexPath) as! HistoryCell
        let operation = History.GetHistory().Operations[indexPath.row]
        cell.configure(from: operation)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return History.GetHistory().Operations.count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}