//
//  TasksController.swift
//  Taskee
//
//  Created by Mark Kim on 9/29/20.
//

import UIKit
import CoreData

class TasksController: UIViewController {
    
    var project: Project?
    var store: CoreDataStack!
    var task: Task!
    
    let dateFormatter = DateFormatter()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchResult: NSFetchRequest<Task> = Task.fetchRequest()
        let sortResults = NSSortDescriptor(key: "due", ascending: true)
        fetchResult.sortDescriptors = [sortResults]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchResult, managedObjectContext: store.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private let toDoCompleteSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Todo", at: 0, animated: true)
        segment.insertSegment(withTitle: "Done", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(switchStatus), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private let taskTableView: UITableView = {
        let table = UITableView()
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubViews()
        setUpNavBar()
        fetchTodoTasks()
        taskTableView.reloadData()
    }
    
    private func setUpSubViews() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        view.addSubview(toDoCompleteSegment)
        view.addSubview(taskTableView)
        
        NSLayoutConstraint.activate([
            toDoCompleteSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toDoCompleteSegment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            toDoCompleteSegment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            toDoCompleteSegment.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            taskTableView.topAnchor.constraint(equalTo: toDoCompleteSegment.bottomAnchor, constant: 20),
            taskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpNavBar() {
        title = project?.name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    private func fetchTodoTasks(){
        let projectPredicate = NSPredicate(format: "project = %@", project!)
        let statusTodoPredicate = NSPredicate(format: "status = false")
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, statusTodoPredicate])
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
    }
    
    private func fetchDoneTasks(){
        let projectPredicate = NSPredicate(format: "project = %@", project!)
        let statusDonePredicate = NSPredicate(format: "status = true")
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, statusDonePredicate])
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
    }
    
    private func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? TaskTableViewCell else { return }
        let task = fetchedResultsController.object(at: indexPath)
        cell.taskLabel.text = task.title
        cell.status = task.status
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let date = task.due else { return }
        let dueDate = dateFormatter.string(from: date)
        cell.dueDateLabel.text = "Due by: \(dueDate)"
    }
    
    @objc func addTask() {
        let vc = NewEditTaskViewController()
        vc.store = store
        vc.project = project
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func switchStatus() {
        if toDoCompleteSegment.selectedSegmentIndex == 0 {
            fetchTodoTasks()
            taskTableView.reloadData()
        } else {
            fetchDoneTasks()
            taskTableView.reloadData()
        }
    }
}

extension TasksController: UITableViewDelegate {
    
}

extension TasksController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        configureCell(cell: cell, for: indexPath)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        let vc = NewEditTaskViewController()
        vc.project = project
        vc.task = task
        vc.store = store
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.mainContext.delete(fetchedResultsController.object(at: indexPath))
            store.saveContext()
        }
    }
}

extension TasksController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            taskTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            taskTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = taskTableView.cellForRow(at: indexPath!) as! TaskTableViewCell
            configureCell(cell: cell, for: indexPath!)
        case .move:
            taskTableView.deleteRows(at: [indexPath!], with: .automatic)
            taskTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.endUpdates()
    }
}

extension TasksController: TaskTableViewCellDelegate {
    func taskTableViewCell(_ index: IndexPath) {
        task = fetchedResultsController.object(at: index)
        
        if task.status {
            task.status = false
            store.saveContext()
            taskTableView.reloadData()
        } else {
            task.status = true
            store.saveContext()
            taskTableView.reloadData()
        }
    }
}
