//
//  LentaViewController.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaViewInput: AnyObject {
    func reloadLenta()
    func reloadPost(by index: Int)
    func insertPost(by index: Int)
    func insertPosts(fromIndex: Int, toIndex: Int)
    func removePost(by index: Int)
    func showNewPostButton(_ isShow: Bool)
    func show(message: String)
    func showMenu(byPostIndex index: Int, isPostOwner: Bool)
    func activityIndicatorStart()
    func activityIndicatorStop()
    func activityEndRefreshing()
    func set(photo: UIImage?, for index: Int)
    func set(avatar: UIImage?, for index: Int)
}

final class LentaViewController: UIViewController {

    // MARK: - Properties

    private lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem(title: "Lenta")
        navItem.rightBarButtonItem = newPostButtonItem
        return navItem
    }()

    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.items = [navItem]
        navBar.isTranslucent = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()

    private lazy var lentaTableView: UITableView = {
        let table = UITableView()
        table.register(LentaCell.self, forCellReuseIdentifier: LentaCell.reuseID)
        table.dataSource = self
        table.delegate = self
        table.refreshControl = refreshControl
        table.backgroundColor = Constants.Colors.bgTable
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var newPostButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                            target: self, action: #selector(newPostButtonPress))

    var presenter: LentaViewOutput?

    // MARK: - LifeCycles

    deinit {
        print("LentaViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LentaViewController init")

        setupUI()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.viewWillAppear()
    }

    // MARK: - Methods

    @objc private func pullToRefresh() {
        presenter?.didPressToRefresh()
    }

    @objc private func newPostButtonPress() {
        presenter?.didPressNewPost()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(lentaTableView)
        view.addSubview(navigationBar)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            lentaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lentaTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            lentaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lentaTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -58)
        ])
    }
}

// MARK: - UITableViewDataSource

extension LentaViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.postsViewModel.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LentaCell.reuseID, for: indexPath) as? LentaCell,
              let presenter = presenter else { return UITableViewCell() }
        cell.delegate = self
        let postModel = presenter.postsViewModel[indexPath.row]
        cell.set(postModel: postModel, cellWidth: tableView.bounds.width)
        presenter.loadImages(by: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LentaViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(by: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - PostCellDelegate

extension LentaViewController: PostCellDelegate {

    func didTapAvatar(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter?.didTapAvatar(by: cellIndexPath.row)
        }
    }

    func didTapCommentsButton(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter?.didPressComments(by: cellIndexPath.row)
        }
    }

    func didTapShareButton(cell: UITableViewCell, with object: [Any]) {
        let avc = UIActivityViewController(activityItems: object, applicationActivities: nil)
        avc.popoverPresentationController?.sourceView = cell
        avc.popoverPresentationController?.permittedArrowDirections = .any
//            avc.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        avc.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
//            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]

        avc.isModalInPresentation = true
        present(avc, animated: true)
    }

    func didTapMenuButton(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter?.didPressMenu(by: cellIndexPath.row)
        }
    }

    func didTapLikeButton(cell: UITableViewCell) {
        if let cellIndexPath = lentaTableView.indexPath(for: cell) {
            presenter?.didPressLike(postIndex: cellIndexPath.row)
        }
    }
}

// MARK: - LentaViewInput

extension LentaViewController: LentaViewInput {

    func set(photo: UIImage?, for index: Int) {
        guard let cell = lentaTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? LentaCell else { return }
        cell.set(photo: photo)
    }

    func set(avatar: UIImage?, for index: Int) {
        guard let cell = lentaTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? LentaCell else { return }
        cell.set(avatar: avatar)
    }

    func activityEndRefreshing() {
        print("activityEndRefreshing")
        refreshControl.endRefreshing()
    }

    func activityIndicatorStop() {
        print("activityIndicatorStop")
        activityIndicator.stopAnimating()
    }

    func activityIndicatorStart() {
        print("activityIndicatorStart")
        activityIndicator.startAnimating()
    }

    func showMenu(byPostIndex index: Int, isPostOwner: Bool) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if isPostOwner {

            let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { _ in
                print("delete post")
                self.presenter?.didPressDeletePost(by: index)
            }
            alertController.addAction(deleteAction)
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
        guard let cell = lentaTableView.cellForRow(at: indexPath) as? LentaCell,
              let presenter = presenter else { return }
        cell.likeUpdate(post: presenter.postsViewModel[index])
    }

    func show(message: String) {
        refreshControl.endRefreshing()
        let alertController = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func showNewPostButton(_ isLoginned: Bool) {
        navItem.rightBarButtonItem?.isEnabled = isLoginned
    }

    func reloadLenta() {
        lentaTableView.reloadData()
    }
}
