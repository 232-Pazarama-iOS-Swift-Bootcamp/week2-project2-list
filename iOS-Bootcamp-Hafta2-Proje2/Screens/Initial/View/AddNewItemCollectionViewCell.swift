//
//  AddNewItemCollectionViewCell.swift
//  iOS-Bootcamp-Hafta2-Proje2
//
//  Created by Muhammed Karakul on 25.09.2022.
//

import UIKit

protocol AddNewItemCollectionViewCellDelegate: AnyObject {
    func didTapped()
}

final class AddNewItemCollectionViewCell: UICollectionViewCell {

    weak var delegate: AddNewItemCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UIGestureRecognizer(target: self, action: #selector(didTapped(_:)))
        
    }

    @IBAction private func didTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapped()
    }
}
