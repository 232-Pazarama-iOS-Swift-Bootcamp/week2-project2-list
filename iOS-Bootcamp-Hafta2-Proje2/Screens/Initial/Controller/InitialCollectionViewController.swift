//
//  InitialCollectionViewController.swift
//  iOS-Bootcamp-Hafta2-Proje2
//
//  Created by Muhammed Karakul on 25.09.2022.
//

import UIKit

private let reuseIdentifier = "AddNewItemCollectionViewCell"

final class InitialViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main"
        
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension InitialViewController: UICollectionViewDelegateFlowLayout,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddNewItemCollectionViewCell
        cell.delegate = self
        // Configure the cell
        
        
        return cell
    }
}

extension InitialViewController: AddNewItemCollectionViewCellDelegate {
    func didTapped() {
        print("CELL TAPPED")
    }
}
