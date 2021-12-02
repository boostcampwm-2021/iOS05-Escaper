//
//  ImageCacheManager.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/11.
//

import Firebase
import FirebaseStorage
import UIKit

class ImageCacheManager {
    typealias URLCompletion = (Result<String, Error>) -> Void
    typealias DataCompletion = (Result<Data, Error>) -> Void

    static let shared = ImageCacheManager()

    private let imageCacheQueue = DispatchQueue(label: "imageCache")
    private let fileManager = FileManager.default
    private let storage = Storage.storage()
    private let cachePath = URL(string: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
    lazy private var cache: URLCache = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("DownloadedCache")
        let cache = URLCache(memoryCapacity: 0, diskCapacity: 100_000_000, directory: diskCacheURL)
        return cache
    }()
    lazy private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()

    private init() {}

    func download(urlString: String, completion: @escaping DataCompletion) {
        self.storage.reference(forURL: urlString).downloadURL { url, _ in
            guard let url = url else { return }
            let request = URLRequest(url: url)
            if let data = self.cache.cachedResponse(for: request)?.data {
                completion(.success(data))
                return
            }
            let downloadTask = URLSession.shared.downloadTask(with: request) { [weak self] url, response, _ in
                if let data = self?.cache.cachedResponse(for: request)?.data {
                    completion(.success(data))
                    return
                }
                if let response = response, let localURL = url,
                   self?.cache.cachedResponse(for: request) == nil,
                   let data = try? Data(contentsOf: localURL, options: [.mappedIfSafe]) {
                    self?.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                    completion(.success(data))
                }
            }
            downloadTask.resume()
        }
    }
}
