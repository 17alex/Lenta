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

    //MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var newCommentTextView: UITextView!
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var heightNewCommentTextView: NSLayoutConstraint!
    @IBOutlet weak var bottomBabbleView: NSLayoutConstraint!

    //MARK: - Propertis
    
    var presenter: CommentsViewOutput!
    var kbIsShow = false
    
    //MARK: - LiveCycles
    
    deinit {
        print("CommentsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CommentsViewController init")
        
        setup()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        descriptionTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - Metods
    
    @objc private func willShowKboard(notification: NSNotification) {
        if kbIsShow == true { return }
        kbIsShow = true
        
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let offset = kbFrameSize.height
        
        UIView.animate(withDuration: 0.5) {
            self.bottomBabbleView.constant = -offset - 5
            self.view.layoutIfNeeded()
        } completion: { (_) in
            let countRow = self.presenter.commentsViewModel.count
            self.commentsTableView.scrollToRow(at: IndexPath(row: countRow == 0 ? 0 : countRow - 1, section: 1), at: .middle, animated: true)
        }

    }
    
    @objc private func willHideKboard() {
        if kbIsShow == false { return }
        kbIsShow = false
        
        UIView.animate(withDuration: 0.5) {
            self.bottomBabbleView.constant = -5
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func hideKboard() {
        newCommentTextView.resignFirstResponder()
    }

    private func setup() {
        activityIndicator.hidesWhenStopped = true
        bubleView.layer.cornerRadius = 15
        let postCellNibName = String(describing: PostCell.self)
        commentsTableView.register(UINib(nibName: postCellNibName, bundle: nil), forCellReuseIdentifier: postCellNibName)
        let commentCellNibName = String(describing: CommentCell.self)
        commentsTableView.register(UINib(nibName: commentCellNibName, bundle: nil), forCellReuseIdentifier: commentCellNibName)
        commentsTableView.dataSource = self
        newCommentTextView.delegate = self
        commentsTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKboard)))
        bubleView.layer.borderWidth = 1
        bubleView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //Mark: - IBAction
    
    @IBAction func sendButtonPress(_ sender: UIButton) {
        print("sendNewComment")
        guard let newComment = newCommentTextView.text, !newComment.isEmpty else { return }
        presenter.didPressNewCommendSendButton(comment: newComment)
        newCommentTextView.text = ""
        heightNewCommentTextView.constant = 33
    }
    
    @IBAction func closeButtonPress(_ sender: UIButton) {
        presenter.didCloseButtonPress()
    }
}

//MARK: - CommentsViewInput

extension CommentsViewController: CommentsViewInput {
    
    func addRow() {
        commentsTableView.insertRows(at: [IndexPath(row: presenter.commentsViewModel.count - 1, section: 1)], with: .top)
        let countRow = self.presenter.commentsViewModel.count
        commentsTableView.scrollToRow(at: IndexPath(row: countRow == 0 ? 0 : countRow - 1, section: 1), at: .middle, animated: true)
    }
    
    func show(message: String) {
        let alertController = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadComments() {
        commentsTableView.reloadData()
//        let countRow = self.presenter.commentsViewModel.count
//        commentsTableView.scrollToRow(at: IndexPath(row: countRow == 0 ? 0 : countRow - 1, section: 1), at: .bottom, animated: false)
    }
    
    func loadingEnd() {
        activityIndicator.stopAnimating()
    }
    
    func loadingStarted() {
        activityIndicator.startAnimating()
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
        let estimatedSize = newCommentTextView.sizeThatFits(size)
        heightNewCommentTextView.constant = estimatedSize.height
    }
}
