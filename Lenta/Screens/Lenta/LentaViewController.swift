//
//  LentaViewController.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaViewInput: class {
    func reloadLenta()
    func reloadPost(by index: Int)
    func insertPost(by index: Int)
    func insertPosts(fromIndex: Int, toIndex: Int)
    func removePost(by index: Int)
    func userLoginned(_ isLoginned: Bool)
    func show(message: String)
    func showMenu(byPostIndex index: Int, isOwner: Bool)
}

final class LentaViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var lentaTableView: UITableView! {
        didSet {
            let nibName = String(describing: LentaCell.self)
            lentaTableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
            lentaTableView.dataSource = self
            lentaTableView.delegate = self
            lentaTableView.refreshControl = refreshControl
        }
    }
    
    //MARK: - Variables
    
    var presenter: LentaViewOutput!
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - LiveCycles
    
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
    
    //MARK: - Metods
    
    private func setup() {
        title = "Lenta"
        activityIndicator.startAnimating()
        let newPostButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newPostButtonPress))
        navigationItem.rightBarButtonItem = newPostButtonItem
    }
    
    @objc private func pullToRefresh() {
        presenter.didPressToRefresh()
    }
    
    @objc private func newPostButtonPress() {
        presenter.didPressNewPost()
    }
}

//MARK: - UITableViewDataSource

extension LentaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.postsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LentaCell.self), for: indexPath) as! LentaCell
        cell.delegate = self
        let postModel = presenter.postsViewModel[indexPath.row]
        cell.set(postModel: postModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension LentaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCell(by: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return presenter.postsViewModel[indexPath.row].totalHieght
//    }
}

//MARK: - PostCellDelegate

extension LentaViewController: PostCellDelegate {
    
    func didTapMenuButton(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter.didPressMenu(by: cellIndexPath.row)
        }
    }
    
    func didTapLikeButton(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter.didPressLike(postIndex: cellIndexPath.row)
        }
    }
    
//    func didTapMoreButton(cell: UITableViewCell) {
//        if let cell = cell as? LentaCell, let cellIndexPath = lentaTableView.indexPath(for: cell) {
//            presenter.didPressMore(postIndex: cellIndexPath.row)
//            lentaTableView.beginUpdates()
//            cell.updateMoreText(post: presenter.postsViewModel[cellIndexPath.row])
//            lentaTableView.reloadRows(at: [cellIndexPath], with: .fade)
//            lentaTableView.endUpdates()
//        }
//    }
}

//MARK: - LentaViewInput

extension LentaViewController: LentaViewInput {
    
    func showMenu(byPostIndex index: Int, isOwner: Bool) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if isOwner {
            let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { action in
                print("delete post")
                self.presenter.didPressDeletePost(by: index)
            }
            alertController.addAction(deleteAction)
            
            let changeAction = UIAlertAction(title: "Change Post", style: .default) { action in
                print("change post")
            }
            alertController.addAction(changeAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func removePost(by index: Int) {
        lentaTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
    }
    
    func insertPost(by index: Int) {
        lentaTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func insertPosts(fromIndex: Int, toIndex: Int) {
        let indexPaths: [IndexPath] = (fromIndex..<toIndex).map { IndexPath(row: $0, section: 0) }
        lentaTableView.insertRows(at: indexPaths, with: .fade)
    }
    
    func reloadPost(by index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = lentaTableView.cellForRow(at: indexPath) as! LentaCell
        cell.smallUpdate(post: presenter.postsViewModel[index])
    }
    
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
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        lentaTableView.reloadData()
    }
}
