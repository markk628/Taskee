//
//  HomeController.swift
//  Taskee
//
//  Created by Mark Kim on 9/22/20.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    var store = CoreDataStack(modelName: "Taskee")
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: store.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private let projectTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 100
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubViews()
        setUpNavBar()
        fetchResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchResults()
        projectTableView.reloadData()
    }
    
    private func fetchResults() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    private func setUpSubViews() {
        projectTableView.dataSource = self
        projectTableView.delegate = self
        view.addSubview(projectTableView)
        NSLayoutConstraint.activate([
            projectTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            projectTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setUpNavBar() {
        title = "Projects"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateProjectController))
    }
    
    private func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? ProjectTableViewCell else { return }
        let project = fetchedResultsController.object(at: indexPath)
        var count = 0
        cell.projectTitle.text = project.name
        
        guard let color = project.color else {
            return cell.projectColorView.backgroundColor = nil
        }
        cell.projectColorView.backgroundColor = color
        
        guard let tasks = project.tasks else { return }
        for _ in tasks {
            count += 1
        }
        cell.taskLabel.text = "\(count) tasks"
    }
    
    @objc func goToCreateProjectController() {
        let vc = AddProjectController()
        vc.store = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeController: UITableViewDelegate {
    
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier, for: indexPath) as! ProjectTableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = fetchedResultsController.object(at: indexPath)
        let vc = TasksController()
        vc.store = store
        vc.project = project
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.mainContext.delete(fetchedResultsController.object(at: indexPath))
            store.saveContext()
        }
    }
}

extension HomeController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        projectTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            projectTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            projectTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = projectTableView.cellForRow(at: indexPath!) as! ProjectTableViewCell
            configureCell(cell: cell, for: indexPath!)
        case.move:
            projectTableView.deleteRows(at: [indexPath!], with: .automatic)
            projectTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        projectTableView.endUpdates()
    }
}

