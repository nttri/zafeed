//
//  FeedPresenter.swift
//  ZAFeed
//
//  Created by tringuyen3297 on 25/03/2022.
//

import Foundation
import AuthenticationServices

protocol FeedPresenterProtocol: class {
    init(view: ViewControllerProtocol)
    func viewDidLoad()
    func loadMoreFeeds(from feeds: [Feed])
    func like(feed: Feed, handler: @escaping () -> Void)
}

final class FeedPresenter: NSObject, FeedPresenterProtocol {
    weak var view: ViewControllerProtocol?
    
    init(view: ViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        self.loadFeedsData()
    }
    
    func loadMoreFeeds(from feeds: [Feed]) {
        let currentPage = feeds.count / 10
        self.loadFeedsData(from: currentPage)
    }
    
    func like(feed: Feed, handler: @escaping () -> Void) {
        let likePhotoURL = String(format: K.api_unsplash_photos_like, feed.id)
        guard let urlComponent = URLComponents(string: likePhotoURL) else {
            return
        }
        
        let token = UserDefaults.standard.string(forKey: K.app_field_access_token) ?? ""
        let baerer = "Bearer \(token)"
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = feed.liked_by_user ? K.api_method_delete : K.api_method_post
        request.setValue(baerer, forHTTPHeaderField: K.api_field_authorization)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 401 else {
                    self?.view?.handleOnLoginFlow {
                        self?.runLoginFlow()
                    }
                    return
                }
                //perform like/unlike action
                handler()
            }
        }
        task.resume()
    }
    
    private func loadFeedsData(from page: Int = 1) {
        guard var urlComponent = URLComponents(string: K.api_unsplash_photos_url) else {
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: K.api_unsplash_field_page, value: "\(page)")
        ]
        
        let token = UserDefaults.standard.string(forKey: K.app_field_access_token) ?? ""
        let client_id = "Client-ID \(K.api_access_token)"
        let baerer = "Bearer \(token)"
        let id_value = token.isEmpty ? client_id : baerer
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = K.api_method_get
        request.setValue(id_value, forHTTPHeaderField: K.api_field_authorization)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.handleGetFeedsOn(data: data, error: error)
            }
        }
        task.resume()
    }
    
    private func handleGetFeedsOn(data: Data?, error: Error?) {
        if let sError = error {
            self.handle(on: sError)
            return
        }
        guard let sData = data else {
            return
        }
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode([Feed].self, from: sData)
            self.view?.onFeedsDataReceived(with: decodedData)
        } catch {
            self.handle(on: error)
        }
    }
    
    private func handle(on error: Error) {
        print("Error detail: \(error)")
        self.view?.handle(on: error)
    }
    
    private func runLoginFlow() {
        directToUnsplashAuthorize { code in
            //request token
            guard var urlComponent = URLComponents(string: K.api_unsplash_request_token) else {
                return
            }
            urlComponent.queryItems = [
                URLQueryItem(name: K.api_unsplash_field_client_id, value: K.api_access_token),
                URLQueryItem(name: K.api_unsplash_field_client_secret, value: K.api_secret_key),
                URLQueryItem(name: K.api_unsplash_field_redirect_uri, value: K.app_redirect_uri),
                URLQueryItem(name: K.api_unsplash_field_code, value: code),
                URLQueryItem(name: K.api_unsplash_grant_type, value: K.api_unsplash_authorization_code),
            ]
            
            var request = URLRequest(url: urlComponent.url!)
            request.httpMethod = K.api_method_post

            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let sData = data else {
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    let tokenResponse = try jsonDecoder.decode(RequestTokenResponse.self, from: sData)
                    UserDefaults.standard.set(tokenResponse.access_token, forKey: K.app_field_access_token)
                } catch {
                    self?.handle(on: error)
                }
            }
            task.resume()
        }
    }
    
    private func directToUnsplashAuthorize(_ completionHandler: @escaping (String) -> Void) {
        let params = [
            URLQueryItem(name: K.api_unsplash_field_client_id, value: K.api_access_token),
            URLQueryItem(name: K.api_unsplash_field_redirect_uri, value: K.app_redirect_uri),
            URLQueryItem(name: K.api_unsplash_field_response_type, value: K.api_unsplash_field_code),
            URLQueryItem(name: K.api_unsplash_field_scope, value: K.app_write_like_scope),
        ]

        var urlComponents = URLComponents(string: K.api_unsplash_authorize)!
        urlComponents.queryItems = params

        let authSession = ASWebAuthenticationSession(url: urlComponents.url!, callbackURLScheme: K.app_url_scheme){ (callbackURL, error) in
            DispatchQueue.main.async {
                guard error == nil, let callbackURL = callbackURL else {
                    return
                }
                guard let code = callbackURL.value(of: K.api_unsplash_field_code) else {
                    return
                }
                completionHandler(code)
            }
        }

        authSession.presentationContextProvider = self
        authSession.prefersEphemeralWebBrowserSession = true
        authSession.start()
    }
}

extension FeedPresenter: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
