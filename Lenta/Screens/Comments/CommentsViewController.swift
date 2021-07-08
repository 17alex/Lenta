//
//  CommentsViewController.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import UIKit

protocol CommentsViewInput: class {
    func showActivityIndicator()
    func loadingEnd()
    func reloadComments()
    func addRow()
    func show(message: String)
}

final class CommentsViewController: UIViewController {

    //MARK: - Propertis
    
    private lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem(title: "Comments")
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPress))
        navItem.rightBarButtonItem = closeButton
        return navItem
    }()
    
    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.items = [navItem]
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private lazy var tableTap = UITapGestureRecognizer(target: self, action: #selector(hideKboard))
    
    private lazy var commentsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        table.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseID)
        table.dataSource = self
//        table.delegate = self
        table.tableFooterView = UIView()
        table.addGestureRecognizer(tableTap)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var newCommentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.autocapitalizationType = .sentences
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var sendActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var newCommentTextViewHeight: NSLayoutConstraint?
    private let newCommentTextViewHeightDefaultConstant: CGFloat = 33
    
    private var babbleViewBottom: NSLayoutConstraint?
    private let babbleViewBottomDefaultConstant: CGFloat = -5
    
    private var isShowKboard = false
    
    var presenter: CommentsViewOutput?
    
    //MARK: - LiveCycles
    
    deinit {
        print("CommentsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CommentsViewController init")
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKboardNotofication()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        unSubscribeKboardNotofication()
    }

    //MARK: - Metods
    
    private func subscribeKboardNotofication() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unSubscribeKboardNotofication() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func willShowKboard(notification: NSNotification) {
        if isShowKboard { return }
        isShowKboard = true
        
        guard let userInfo = notification.userInfo,
              let animDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double,
              let kbFrameEndUserInfoKey = userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue else { return }
        let kbFrameSize = (kbFrameEndUserInfoKey).cgRectValue
        let offset = kbFrameSize.height
        
        UIView.animate(withDuration: animDuration) {
            self.babbleViewBottom?.constant = self.babbleViewBottomDefaultConstant - offset
            self.view.layoutIfNeeded()
        } completion: { _ in
            let countRow = self.presenter?.commentsViewModel.count ?? 0
            if countRow != 0 {
                self.commentsTableView.scrollToRow(at: IndexPath(row: countRow - 1, section: 1), at: .bottom, animated: true)
            } else {
                self.commentsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    @objc private func willHideKboard(notification: NSNotification) {
        if isShowKboard == false { return }
        isShowKboard = false
        
        guard let userInfo = notification.userInfo,
              let animDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }
        
        UIView.animate(withDuration: animDuration) {
            self.babbleViewBottom?.constant = self.babbleViewBottomDefaultConstant
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func hideKboard() {
        newCommentTextView.resignFirstResponder()
    }
    
    private func animateActivity(_ isAnimate: Bool) {
        if isAnimate {
            sendActivityIndicator.startAnimating()
            sendButton.isHidden = true
        } else {
            sendActivityIndicator.stopAnimating()
            sendButton.isHidden = false
        }
    }
    
    @objc private func sendButtonPress() {
        print("sendNewComment")
        guard let newComment = newCommentTextView.text, !newComment.isEmpty else { return }
        animateActivity(true)
        presenter?.didPressNewCommendSendButton(comment: newComment)
        newCommentTextView.text = ""
        newCommentTextViewHeight?.constant = newCommentTextViewHeightDefaultConstant
    }
    
    @objc private func closeButtonPress() {
        presenter?.didCloseButtonPress()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(navBar)
        view.addSubview(commentsTableView)
        view.addSubview(cardView)
        view.addSubview(sendButton)
        view.addSubview(sendActivityIndicator)
        view.addSubview(loadActivityIndicator)
        cardView.addSubview(newCommentTextView)
        
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentsTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sendButton.leadingAnchor.constraint(equalTo: cardView.trailingAnchor),
            sendButton.topAnchor.constraint(equalTo: cardView.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            cardView.topAnchor.constraint(equalTo: commentsTableView.bottomAnchor, constant: 5),
            
            newCommentTextView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 5),
            newCommentTextView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 2),
            newCommentTextView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -5),
            newCommentTextView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -2),
            
            sendActivityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            sendActivityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
            
            loadActivityIndicator.centerXAnchor.constraint(equalTo: commentsTableView.centerXAnchor),
            loadActivityIndicator.centerYAnchor.constraint(equalTo: commentsTableView.centerYAnchor),
        ])
        
        newCommentTextViewHeight = newCommentTextView.heightAnchor.constraint(equalToConstant: newCommentTextViewHeightDefaultConstant)
        newCommentTextViewHeight?.isActive = true
        
        babbleViewBottom = cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: babbleViewBottomDefaultConstant)
        babbleViewBottom?.isActive = true
    }
}

//MARK: - CommentsViewInput

extension CommentsViewController: CommentsViewInput {
    
    func addRow() {
        guard let presenter = presenter else { return }
        commentsTableView.insertRows(at: [IndexPath(row: presenter.commentsViewModel.count - 1, section: 1)], with: .top)
        let countRow = presenter.commentsViewModel.count
        commentsTableView.scrollToRow(at: IndexPath(row: countRow - 1, section: 1), at: .middle, animated: true)
        animateActivity(false)
    }
    
    func show(message: String) {
        let alertController = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        animateActivity(false)
    }
    
    func reloadComments() {
        commentsTableView.reloadData()
    }
    
    func loadingEnd() {
        loadActivityIndicator.stopAnimating()
    }
    
    func showActivityIndicator() {
        loadActivityIndicator.startAnimating()
    }
}

//MARK: - UITableViewDataSource

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.cellTypes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        switch presenter.cellTypes[section] {
        case .post:
            return presenter.postsViewModel.count
        case .comments:
            return presenter.commentsViewModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else { return UITableViewCell() }
        switch presenter.cellTypes[indexPath.section] {
        case .post:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as? PostCell else { return UITableViewCell() }
            let postViewModel = presenter.postsViewModel[indexPath.row]
            cell.set(postModel: postViewModel)
            return cell
        case .comments:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseID, for: indexPath) as? CommentCell else { return UITableViewCell() }
            let commentViewModel = presenter.commentsViewModel[indexPath.row]
            cell.set(commentModel: commentViewModel)
            return cell
        }
    }
}

//MARK: - UITextViewDelegate

extension CommentsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: newCommentTextView.frame.width, height: .infinity)
        let estimatedSize = newCommentTextView.sizeThatFits(size) //TODO: - max to navBar
        newCommentTextViewHeight?.constant = estimatedSize.height
    }
}
