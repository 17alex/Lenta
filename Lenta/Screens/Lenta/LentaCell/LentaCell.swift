//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

final class LentaCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var fotoActivityIndicator: UIActivityIndicatorView! {
        didSet {
            fotoActivityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var heightFotoImageView: NSLayoutConstraint!
    @IBOutlet weak var heightDescriptionLabel: NSLayoutConstraint!
    
    var logoImageViewUrl: URL!
    var fotoImageViewUrl: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.layer.cornerRadius = 30
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fotoImageView.image = nil
    }
    
    func set(post: PostViewModel) {
        userNameLabel.text = post.userName + " postId = \(post.id)"
        setAvatar(avatarName: post.avatarImageName)
        timeLabel.text = post.time
        descriptionLabel.text = post.description
        let imHeight: CGFloat = calculateImageHeight(imageWidth: post.postImageWidth, imageHeight: post.postImageHeight)
        print("post.id=\(post.id); Width=\(post.postImageWidth); Height=\(post.postImageHeight); bounds.width=\(UIScreen.main.bounds.width); imHeight=\(imHeight)")
        heightFotoImageView.constant = imHeight
        setPostImage(postImageName: post.postImageName)
//        layoutIfNeeded()
    }
    
    private func setPostImage(postImageName: String) {
        if postImageName != "", let url = URL(string: "https://monsterok.ru/lenta/images/\(postImageName)") {
            fotoActivityIndicator.startAnimating()
            fotoImageViewUrl = url
            loadImage(for: url) { (image, imageUrl) in
                if self.fotoImageViewUrl.absoluteString == imageUrl.absoluteString {
                    self.fotoActivityIndicator.stopAnimating()
                    self.fotoImageView.image = image
                }
            }
        }
    }
    
    private func setAvatar(avatarName: String) {
        if avatarName != "", let url = URL(string: "https://monsterok.ru/lenta/avatars/\(avatarName)") {
            logoImageViewUrl = url
            loadImage(for: url) { (image, imageUrl) in
                if self.logoImageViewUrl.absoluteString == imageUrl.absoluteString {
                    self.logoImageView.image = image
                }
            }
        } else {
            logoImageView.image = UIImage(named: "defaultAvatar")
        }
    }
    
    private func calculateImageHeight(imageWidth: Int, imageHeight: Int) -> CGFloat {
        let imageRatio = CGFloat(imageWidth) / CGFloat(imageHeight)
        let widthSizeFotoImageView = UIScreen.main.bounds.width
        return widthSizeFotoImageView / CGFloat(imageRatio)
    }
    
    //TODO: todo
    private func loadImage(for url: URL, complete: @escaping (UIImage, URL) -> Void) {
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, _) in
            if let data = data, let loadImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    complete(loadImage, url)
                }
            }
        }.resume()
    }
    
    @IBAction func moreButtonPress() {
        
    }
}
