//
//  LentaViewController.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaViewInput: class {
    func reloadLenta()
}

class LentaViewController: UIViewController {

    @IBOutlet weak var lentaTableView: UITableView! {
        didSet {
            let nibName = String(describing: LentaCell.self)
            lentaTableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
            lentaTableView.dataSource = self
            lentaTableView.delegate = self
        }
    }
    
    var presenter: LentaViewOutput!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    private func setup() {
        title = "Lenta"
        
        let newButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addButtonPress))
        navigationItem.rightBarButtonItem = newButtonItem
        
        let updateButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(update))
        navigationItem.leftBarButtonItem = updateButtonItem
    }
    
    @objc
    func addButtonPress() {
        presenter.addButtonPress()
    }
    
    @objc
    func update() {
        presenter.viewDidLoad()
    }
}

//MARK: - UITableViewDataSource

extension LentaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.postCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LentaCell.self), for: indexPath) as! LentaCell
        let post = presenter.postViewModel(for: indexPath.item)
        cell.set(post: post)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension LentaViewController: UITableViewDelegate {
    
}

//MARK: - LentaViewInput

extension LentaViewController: LentaViewInput {
    
    func reloadLenta() {
        lentaTableView.reloadData()
    }
}
