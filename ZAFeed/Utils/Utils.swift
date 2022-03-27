//
//  Utils.swift
//  ZAFeed
//
//  Created by tringuyen3297 on 26/03/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}

extension URL {
    func value(of name: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == name })?.value
    }
}
