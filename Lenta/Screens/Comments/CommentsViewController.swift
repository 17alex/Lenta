//
//  CommentsViewController.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import UIKit

protocol CommentsViewInput: class {
    func loadingStarted()
    func loadingEnd()
    func reloadComments()
    func addRow()
    func show(message: String)
}

class CommentsViewController: UIViewController {

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
        let postCellNibName = String(describing: PostCell.self)
        table.register(UINib(nibName: postCellNibName, bundle: nil), forCellReuseIdentifier: postCellNibName)
        let commentCellNibName = String(describing: CommentCell.self)
        table.register(UINib(nibName: commentCellNibName, bundle: nil), forCellReuseIdentifier: commentCellNibName)
        table.dataSource = self
        table.delegate = self
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
    
    private lazy var bubleView: UIView = { //TODO: - rename to cardView
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var heightNewCommentTextView: NSLayoutConstraint!
    private var bottomBabbleView: NSLayoutConstraint!
    
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
    
    var presenter: CommentsViewOutput!
    private var isShowKboard = false
    
    //MARK: - LiveCycles
    
    deinit {
        print("CommentsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CommentsViewController init")
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: - out in metod
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: - out in metod
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - Metods
    
    @objc private func willShowKboard(notification: NSNotification) {
        if isShowKboard { return }
        isShowKboard = true
        
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let offset = kbFrameSize.height
        
        UIView.animate(withDuration: 0.5) {
            self.bottomBabbleView.constant = -offset - 5
            self.view.layoutIfNeeded()
        } completion: { (_) in
            let countRow = self.presenter.commentsViewModel.count
            if countRow != 0 {
                self.commentsTableView.scrollToRow(at: IndexPath(row: countRow - 1, section: 1), at: .middle, animated: true)
            } else {
                self.commentsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    @objc private func willHideKboard() {
        if isShowKboard == false { return }
        isShowKboard = false
        
        UIView.animate(withDuration: 0.5) {
            self.bottomBabbleView.constant = -5
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func hideKboard() {
        newCommentTextView.resignFirstResponder()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(navBar)
        view.addSubview(commentsTableView)
        view.addSubview(bubleView)
        view.addSubview(sendButton)
        view.addSubview(sendActivityIndicator)
        view.addSubview(loadActivityIndicator)
        bubleView.addSubview(newCommentTextView)
        
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentsTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sendButton.leadingAnchor.constraint(equalTo: bubleView.trailingAnchor),
            sendButton.topAnchor.constraint(equalTo: bubleView.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            
            bubleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            bubleView.topAnchor.constraint(equalTo: commentsTableView.bottomAnchor, constant: 5),
            
            newCommentTextView.leadingAnchor.constraint(equalTo: bubleView.leadingAnchor, constant: 5),
            newCommentTextView.topAnchor.constraint(equalTo: bubleView.topAnchor, constant: 2),
            newCommentTextView.trailingAnchor.constraint(equalTo: bubleView.trailingAnchor, constant: -5),
            newCommentTextView.bottomAnchor.constraint(equalTo: bubleView.bottomAnchor, constant: -2),
            
            sendActivityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            sendActivityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
            
            loadActivityIndicator.centerXAnchor.constraint(equalTo: commentsTableView.centerXAnchor),
            loadActivityIndicator.centerYAnchor.constraint(equalTo: commentsTableView.centerYAnchor),
        ])
        
        heightNewCommentTextView = newCommentTextView.heightAnchor.constraint(equalToConstant: 33)
        heightNewCommentTextView.isActive = true
        
        bottomBabbleView = bubleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        bottomBabbleView.isActive = true
        
        bubleView.layer.cornerRadius = 15
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
        presenter.didPressNewCommendSendButton(comment: newComment)
        newCommentTextView.text = ""
        heightNewCommentTextView.constant = 33 //TODO: - nameConstant
    }
    
    @objc private func closeButtonPress() {
        presenter.didCloseButtonPress()
    }
}

//MARK: - CommentsViewInput

extension CommentsViewController: CommentsViewInput {
    
    func addRow() {
        commentsTableView.insertRows(at: [IndexPath(row: presenter.commentsViewModel.count - 1, section: 1)], with: .top)
        let countRow = self.presenter.commentsViewModel.count
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
    
    func loadingStarted() {
        loadActivityIndicator.startAnimating()
    }
}

//MARK: - UITableViewDataSource

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch presenter.cellTypes[section] {
        case .post:
            return presenter.postsViewModel.count
        case .comments:
            return presenter.commentsViewModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.cellTypes[indexPath.section] {
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostCell.self), for: indexPath) as! PostCell
            let postViewModel = presenter.postsViewModel[indexPath.row]
            cell.set(postModel: postViewModel)
            return cell
        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as! CommentCell
            let commentViewModel = presenter.commentsViewModel[indexPath.row]
            cell.set(commentModel: commentViewModel)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension CommentsViewController: UITableViewDelegate {
    
}

//MARK: - UITextViewDelegate

extension CommentsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: newCommentTextView.frame.width, height: .infinity)
        let estimatedSize = newCommentTextView.sizeThatFits(size) //TODO: - max to navBar
        heightNewCommentTextView.constant = estimatedSize.height
    }
}
