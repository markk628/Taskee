//
//  TaskTableViewCell.swift
//  Taskee
//
//  Created by Mark Kim on 9/29/20.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func taskTableViewCell(_ index: IndexPath)
}

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    var status: Bool = false
    
    weak var delegate: TaskTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    let checkBoxButton: UIButton = {
        let button = UIButton()
        let green = UIColor.green
        button.layer.cornerRadius = 5
        button.layer.borderColor = green.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dueDateLabel: UILabel = {
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
        checkBoxButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    }
    
    private func setUpSubViews() {
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(taskLabel)
        contentView.addSubview(dueDateLabel)
        
        NSLayoutConstraint.activate([
            checkBoxButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.07),
            checkBoxButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            checkBoxButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            checkBoxButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            taskLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            taskLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            taskLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 20),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            dueDateLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 5),
            dueDateLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 20),
            dueDateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    @objc func checkBoxButtonTapped() {
        if let _ = delegate {
            if status == false {
                checkBoxButton.backgroundColor = .green
                status = true
                delegate?.taskTableViewCell(indexPath!)
            } else {
                checkBoxButton.backgroundColor = .clear
                status = false
                delegate?.taskTableViewCell(indexPath!)
            }
        }
    }
}
