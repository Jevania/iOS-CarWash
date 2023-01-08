//
//  CarTableViewCell.swift
//  CarWash
//
//  Created by jevania on 07/01/23.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    static let identifier = "CarTableViewCell"
    
    var carNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Car Name"
        
        return label
    }()
    
    var carIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Car Id"
        
        return label
    }()
    
    var carStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Car Status"
        label.textColor = .systemBlue
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(carNameLabel)
        contentView.addSubview(carIdLabel)
        contentView.addSubview(carStatusLabel)
        
        configureConstraints()
    }
    
    private func configureConstraints(){
        
        let carNameLabelConstraints = [
            carNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            carNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ]
        
        let carIdLabelConstraints = [
            carIdLabel.leadingAnchor.constraint(equalTo: carNameLabel.leadingAnchor),
            carIdLabel.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: 5)
        ]
        
        let carStatusLabelConstraints = [
            carStatusLabel.leadingAnchor.constraint(equalTo: carIdLabel.leadingAnchor),
            carStatusLabel.topAnchor.constraint(equalTo: carIdLabel.bottomAnchor, constant: 15)
        ]
        
        NSLayoutConstraint.activate(carNameLabelConstraints)
        NSLayoutConstraint.activate(carIdLabelConstraints)
        NSLayoutConstraint.activate(carStatusLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
