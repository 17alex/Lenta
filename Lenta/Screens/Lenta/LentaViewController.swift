//
//  LentaViewController.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaViewInput: class {
    func reloadLenta()
    func userLoginned(_ isLoginned: Bool)
    func show(message: String)
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
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    @objc private func pullToRefresh() {
        presenter.pullToRefresh()
        
        print("refresh")
    }
    
    private func setup() {
        title = "Lenta"
        
        let newPostButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newPostButtonPress))
        navigationItem.rightBarButtonItem = newPostButtonItem
        
        let menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonPress))
        navigationItem.leftBarButtonItem = menuBarButtonItem
    }
    
    @objc private func newPostButtonPress() {
        presenter.newPostButtonPress()
    }
    
    @objc private func menuButtonPress() {
        presenter.menuButtonPress()
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
    //TODO: - todo
}

//MARK: - LentaViewInput

extension LentaViewController: LentaViewInput {
    
    func show(message: String) {
        refreshControl.endRefreshing()
        let alertController = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func userLoginned(_ isLoginned: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isLoginned
    }
    
    func reloadLenta() {
        refreshControl.endRefreshing()
        lentaTableView.reloadData()
    }
}
