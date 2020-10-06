//
//  NewEditTaskViewController.swift
//  Taskee
//
//  Created by Mark Kim on 9/30/20.
//

import UIKit
import CoreData

class NewEditTaskViewController: UIViewController {
    
    var project: Project?
    var store: CoreDataStack!
    var task: Task?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Due Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "i.e. drink water"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if task != nil {
            setUpEditObjects()
        }
        setUpSubViews()
        setUpNavBar()
    }
    
    private func setUpSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(dueDateLabel)
        view.addSubview(dueDatePicker)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleTextField.heightAnchor.constraint(equalToConstant: 20),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            dueDateLabel.heightAnchor.constraint(equalToConstant: 20),
            dueDateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            dueDateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            dueDatePicker.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 20),
            dueDatePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            
            
        ])
    }
    
    private func setUpNavBar() {
        title = "New Task or Edit"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
    }
    
    private func setUpEditObjects() {
        guard let task = task else { return }
        titleTextField.text = task.title
        dueDatePicker.date = task.due!
    }
    
    @objc func saveTask() {
        if task != nil {
            task?.title = titleTextField.text
            task?.status = false
            task?.due = dueDatePicker.date
            task?.project = project
            store?.saveContext()
        } else {
            let newTask = Task(context: store.mainContext)
            newTask.title = titleTextField.text
            newTask.status = false
            newTask.due = dueDatePicker.date
            newTask.project = project
            store.saveContext()
        }
        
        self.navigationController?.popViewController(animated: true)
    }

}
