//
//  AddProjectController.swift
//  Taskee
//
//  Created by Mark Kim on 9/29/20.
//

import UIKit

class AddProjectController: UIViewController {
    
    var project: Project?
    var store: CoreDataStack?
    
    let colors: [UIColor] = [.lightSalmonPink, .melon, .veryPaleOrange, .dirtyWhite, .magicMint, .periwinkle, .red, .blue, .black]
    var chosenColor: UIColor? = .white
    
    private let projectNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name your project"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubViews()
        setUpNavBar()
    }
    
    private func setUpSubViews() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        view.addSubview(projectNameTextField)
        view.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            projectNameTextField.heightAnchor.constraint(equalToConstant: 50),
            projectNameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            projectNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            colorCollectionView.topAnchor.constraint(equalTo: projectNameTextField.bottomAnchor, constant: 20),
            colorCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            colorCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            colorCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setUpNavBar() {
        title = "New Project or Edit"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
    }
    
    @objc func saveProject() {
        if project == nil {
            let newProject = Project(context: store!.mainContext)
            newProject.name = projectNameTextField.text
            newProject.color = chosenColor
            store?.saveContext()
        } else {
            project?.name = projectNameTextField.text
            project?.color = chosenColor
            store?.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }

}

extension AddProjectController: UICollectionViewDelegate {
    
}

extension AddProjectController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = cell.frame.size.width/2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let gray = UIColor.lightGray
        cell?.isSelected = true
        cell?.layer.borderColor = gray.cgColor
        cell?.layer.borderWidth = 10
        chosenColor = colors[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let clear = UIColor.clear
        cell?.isSelected = false
        cell?.layer.borderColor = clear.cgColor
    }
}

extension AddProjectController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

extension UIColor {
    static var lightSalmonPink = UIColor(red: 255/255, green: 154/255, blue: 162/255, alpha: 1)
    static var melon = UIColor(red: 255/255, green: 183/255, blue: 178/255, alpha: 1)
    static var veryPaleOrange = UIColor(red: 255/255, green: 218/255, blue: 193/255, alpha: 1)
    static var dirtyWhite = UIColor(red: 226/255, green: 240/255, blue: 203/255, alpha: 1)
    static var magicMint = UIColor(red: 181/255, green: 234/255, blue: 215/255, alpha: 1)
    static var periwinkle = UIColor(red: 199/255, green: 206/255, blue: 234/255, alpha: 1)
}
