//
//  MyTableViewCell.swift
//  Weather App
//
//  Created by Alexey Sergeev on 15.11.2021.
//

import UIKit

final class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func configure(title: String, count: String, image: UIImage) {
        titleLabel.text = title
        countLabel.text = count
        myImageView.image = image
    }
}
