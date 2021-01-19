//
//  LentaViewController.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaViewInput: class {
    func reloadLenta()
    func userLoginned(_ loginned: Bool)
}

final class LentaViewController: UIViewController {

    @IBOutlet weak var lentaTableView: UITableView! {
        didSet {
            let nibName = String(describing: LentaCell.self)
            lentaTableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
            lentaTableView.dataSource = self
            lentaTableView.delegate = self
            lentaTableView.refreshControl = refreshControl
        }
    }
    
    var presenter: LentaViewOutput!
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        return refControl
    }()
    
    deinit {
        print("LentaViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LentaViewController init")
        setup()
        presenter.viewDidLoad()
    }
    
    @objc
    private func refreshPosts() {
        presenter.reloadPosts()
        
        print("refresh")
    }
    
    private func setup() {
        title = "Lenta"
        
        let newButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addButtonPress))
        navigationItem.rightBarButtonItem = newButtonItem
    }
    
    @objc func addButtonPress() {
        presenter.newPostButtonPress()
    }
    
    @objc func logInOutButtonPress() {
        presenter.logInOutButtonPress()
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
    
    func userLoginned(_ loginned: Bool) {
        let updateButtonItem: UIBarButtonItem!
        if loginned {
            updateButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(logInOutButtonPress))
        } else {
            updateButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(logInOutButtonPress))
        }
        navigationItem.leftBarButtonItem = updateButtonItem
        
        navigationItem.rightBarButtonItem?.isEnabled = loginned
    }
    
    func reloadLenta() {
        refreshControl.endRefreshing()
        lentaTableView.reloadData()
    }
}
