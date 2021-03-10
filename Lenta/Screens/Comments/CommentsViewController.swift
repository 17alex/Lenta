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
    func show(message: String)
}

class CommentsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            let cellNibName = String(describing: CommentCell.self)
            commentsTableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellNibName)
            commentsTableView.dataSource = self
        }
    }
    
    //MARK: - Variables
    
    var presenter: CommentsViewOutput!
    
    //MARK: - LiveCycles
    
    deinit {
        print("CommentsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LentaViewController init")
        
        setup()
        presenter.viewDidLoad()
    }

    //MARK: - Metods

    private func setup() {
        activityIndicator.hidesWhenStopped = true
    }
    

}

//MARK: - CommentsViewInput

extension CommentsViewController: CommentsViewInput {
    
    func show(message: String) {
        let alertController = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadComments() {
        commentsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.commentsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as! CommentCell
        let commentViewModel = presenter.commentsViewModel[indexPath.row]
        cell.set(commentModel: commentViewModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CommentsViewController: UITableViewDelegate {
    
}
