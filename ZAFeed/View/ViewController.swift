//
//  ViewController.swift
//  ZAFeed
//
//  Created by tringuyen3297 on 25/03/2022.
//

import UIKit

protocol ViewControllerProtocol: class {
    func onFeedsDataReceived(with feedsData: [Feed])
    func handleOnLoginFlow(with handler: @escaping () -> Void)
    func handle(on error: Error)
}

final class ViewController: UIViewController {
    
    var presenter:FeedPresenterProtocol!
    
    private var tableView:UITableView!
    private var feedsData:[Feed] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let headerView = UIView()
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let titleLbl = UILabel()
        titleLbl.text = K.app_screen_tittle
        titleLbl.font = .boldSystemFont(ofSize: 28)
        titleLbl.textAlignment = .center
        headerView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 12).isActive = true
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: K.app_cell_name)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ViewController: ViewControllerProtocol {
    func onFeedsDataReceived(with feedsData: [Feed]) {
        self.feedsData.append(contentsOf: feedsData)
        self.tableView.reloadData()
    }
    
    func handle(on error: Error) {
        let alert = UIAlertController(title: K.app_alert_title,
                                      message: K.app_alert_msg_server_fail,
                                      preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleOnLoginFlow(with handler: @escaping () -> Void) {
        let alert = UIAlertController(title: K.app_alert_title,
                                      message: K.app_alert_msg_need_login_for_like,
                                      preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) {_ in
            handler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastFeedIdx = self.feedsData.count - 1
        guard indexPath.row == lastFeedIdx else { return }
        self.presenter.loadMoreFeeds(from: self.feedsData)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.app_cell_name, for: indexPath) as? FeedTableViewCell, feedsData.count > 0 else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setupCell(with: feedsData[indexPath.row])
        return cell
    }
}

extension ViewController: FeedTableViewCellDelegate {
    func like(on feed: Feed, completionHandler: @escaping () -> Void) {
        self.presenter.like(feed: feed, handler: completionHandler)
    }
}
