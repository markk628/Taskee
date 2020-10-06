//
//  ProjectTableViewCell.swift
//  Taskee
//
//  Created by Mark Kim on 9/24/20.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    static let identifier = "ProjectCell"
    
    let projectColorView: UIView = {
        let color = UIView()
        color.translatesAutoresizingMaskIntoConstraints = false
        return color
    }()
    
    let projectTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        projectColorView.layer.cornerRadius = projectColorView.frame.size.width/2
        projectColorView.clipsToBounds = true
    }
    
    private func setUpSubViews() {
        contentView.backgroundColor = UIColor(red: 239/255, green: 236/255, blue: 241/255, alpha: 1.0)
        contentView.layer.cornerRadius = 10
        contentView.addSubview(projectColorView)
        contentView.addSubview(projectTitle)
        contentView.addSubview(taskLabel)
        
        NSLayoutConstraint.activate([
            projectColorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.115),
            projectColorView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectColorView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            projectColorView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            projectTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            projectTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            projectTitle.leadingAnchor.constraint(equalTo: projectColorView.trailingAnchor, constant: 20),
            projectTitle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            taskLabel.topAnchor.constraint(equalTo: projectTitle.bottomAnchor, constant: 5),
            taskLabel.leadingAnchor.constraint(equalTo: projectColorView.trailingAnchor, constant: 20),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
}
