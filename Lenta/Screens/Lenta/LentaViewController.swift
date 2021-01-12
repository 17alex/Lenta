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

    @IBOutlet weak var lentaCollectionView: UICollectionView! {
        didSet {
            let nibName = String(describing: LentaCell.self)
            lentaCollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
            lentaCollectionView.dataSource = self
            lentaCollectionView.delegate = self
        }
    }
    
    var presenter: LentaViewOutput!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

//MARK: - UICollectionViewDataSource

extension LentaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.postCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LentaCell.self), for: indexPath) as! LentaCell
        let post = presenter.postViewModel(for: indexPath.item)
        cell.set(post: post)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension LentaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 8
        let ratio: CGFloat = 1.1
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
}

extension LentaViewController: LentaViewInput {
    
    func reloadLenta() {
        lentaCollectionView.reloadData()
    }
}
