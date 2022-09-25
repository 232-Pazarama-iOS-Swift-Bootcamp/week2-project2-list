//
//  ProgressTableViewCell.swift
//  iOS-Bootcamp-Hafta2-Proje2
//
//  Created by Muhammed Karakul on 25.09.2022.
//

import UIKit

final class ProgressTableViewCell: UITableViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var progress: Float = .zero {
        didSet {
            progressView.progress = progress
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
