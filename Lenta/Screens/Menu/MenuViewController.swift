//
//  MenuViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol MenuViewInput: class {
    
}

class MenuViewController: UIViewController {

    private lazy var menuTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    var presenter: MenuViewOutput!
    
    deinit {
        print("MenuViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MenuViewController init")
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Settings"
        view.addSubview(menuTableView)
        NSLayoutConstraint.activate([
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.topAnchor.constraint(equalTo: view.topAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MenuViewController: MenuViewInput {
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = presenter.menuTitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didPress(for: indexPath.row)
    }
}
