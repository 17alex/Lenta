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
    func showMenu(byPostIndex index: Int, isPostOwner: Bool)
    func loadingStarted()
    func loadingEnd()
}

final class LentaViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lentaTableView: UITableView! {
        didSet {
            let cellNibName = String(describing: LentaCell.self)
            lentaTableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellNibName)
            lentaTableView.dataSource = self
            lentaTableView.delegate = self
            lentaTableView.refreshControl = refreshControl
//            lentaTableView.rowHeight = 600
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
        activityIndicator.hidesWhenStopped = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.postsViewModel[indexPath.row].totalHieght
    }
}

//MARK: - PostCellDelegate

extension LentaViewController: PostCellDelegate {
    
    func didTapAvatar(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter.didTapAvatar(by: cellIndexPath.row)
        }
    }
    
    func didTapCommentsButton(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter.didPressComments(by: cellIndexPath.row)
        }
    }
    
    func didTapShareButton(cell: UITableViewCell, with object: [Any]) {
        let avc = UIActivityViewController(activityItems: object, applicationActivities: nil)
        if let lentaCell = cell as? LentaCell {
            avc.popoverPresentationController?.sourceView = lentaCell
            avc.popoverPresentationController?.permittedArrowDirections = .any
        }
        present(avc, animated: true)
    }
    
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
}

//MARK: - LentaViewInput

extension LentaViewController: LentaViewInput {
    
    func loadingEnd() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func loadingStarted() {
        activityIndicator.startAnimating()
    }
    
    func showMenu(byPostIndex index: Int, isPostOwner: Bool) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if isPostOwner {
            
            let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { action in
                print("delete post")
                self.presenter.didPressDeletePost(by: index)
            }
            alertController.addAction(deleteAction)
            
            let changeAction = UIAlertAction(title: "Change Post (in dev)", style: .default) { action in
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
        cell.likeUpdate(post: presenter.postsViewModel[index])
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
        lentaTableView.reloadData()
    }
}
