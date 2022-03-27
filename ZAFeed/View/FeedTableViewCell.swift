//
//  FeedTableViewCell.swift
//  ZAFeed
//
//  Created by tringuyen3297 on 25/03/2022.
//

import Foundation
import UIKit

protocol FeedTableViewCellDelegate {
    func like(on feed: Feed, completionHandler: @escaping () -> Void)
}

final class FeedTableViewCell: UITableViewCell {
    var delegate: FeedTableViewCellDelegate!
    private var feed: Feed!
    private var feedImg: UIImageView!
    private var usernameLbl: UILabel!
    private var likeLbl: UILabel!
    private var numOfLikesLbl: UILabel!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        feedImg = UIImageView()
        feedImg.backgroundColor = .lightGray
        feedImg.layer.cornerRadius = 20
        feedImg.clipsToBounds = true
        feedImg.contentMode = .scaleToFill
        contentView.addSubview(feedImg)
        feedImg.translatesAutoresizingMaskIntoConstraints = false
        feedImg.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        feedImg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        feedImg.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        feedImg.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.7).isActive = true
        
        usernameLbl = UILabel()
        usernameLbl.font = .boldSystemFont(ofSize: 20)
        contentView.addSubview(usernameLbl)
        usernameLbl.translatesAutoresizingMaskIntoConstraints = false
        usernameLbl.topAnchor.constraint(equalTo: feedImg.bottomAnchor, constant: 10).isActive = true
        usernameLbl.leadingAnchor.constraint(equalTo: feedImg.leadingAnchor).isActive = true

        likeLbl = UILabel()
        likeLbl.font = .boldSystemFont(ofSize: 18)
        likeLbl.textColor = .systemGreen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTaped))
        likeLbl.isUserInteractionEnabled = true
        likeLbl.addGestureRecognizer(tapGesture)
        contentView.addSubview(likeLbl)
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 10).isActive = true
        likeLbl.leadingAnchor.constraint(equalTo: feedImg.leadingAnchor).isActive = true
        
        numOfLikesLbl = UILabel()
        numOfLikesLbl.font = .systemFont(ofSize: 18)
        numOfLikesLbl.textColor = .lightGray
        contentView.addSubview(numOfLikesLbl)
        numOfLikesLbl.translatesAutoresizingMaskIntoConstraints = false
        numOfLikesLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 10).isActive = true
        numOfLikesLbl.trailingAnchor.constraint(equalTo: feedImg.trailingAnchor).isActive = true
        numOfLikesLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func likeTaped() {
        self.delegate.like(on: self.feed) { [weak self] in
            guard let sSelf = self else {return}
            let isLiking = !sSelf.feed.liked_by_user
            let numOfLikes = isLiking ? sSelf.feed.likes + 1 : sSelf.feed.likes
            
            sSelf.feed.liked_by_user = isLiking
            sSelf.feed.likes = numOfLikes
            
            sSelf.likeLbl.text = isLiking ? K.app_action_unlike : K.app_action_like
            sSelf.numOfLikesLbl.text = numOfLikes > 1 ? "\(numOfLikes) likes" : "\(numOfLikes) like"
        }
    }
    
    func setupCell(with feed: Feed) {
        self.feed = feed
        feedImg.downloaded(from: feed.urls.thumb)
        usernameLbl.text = feed.user.name
        likeLbl.text = feed.liked_by_user ? K.app_action_unlike : K.app_action_like
        numOfLikesLbl.text = feed.likes > 1 ? "\(feed.likes) likes" : "\(feed.likes) like"
    }
}
