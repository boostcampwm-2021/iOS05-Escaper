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

    private let fileManager = FileManager.default
    private let storage = Storage.storage()
    private let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!

    private init() {}

    func download(urlString: String, completion: @escaping DataCompletion) {
        var filePath = URL(fileURLWithPath: cachePath)
        guard let fileName = urlString.components(separatedBy: "/").last else { return }
        filePath.appendPathComponent(fileName)
        if !fileManager.fileExists(atPath: filePath.path) {
            self.storage.reference(forURL: urlString).downloadURL { url, error in
                guard let url = url else { return }
                NetworkService.shared.downloadImage(from: url) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let localURL):
                        try? self.fileManager.moveItem(at: localURL, to: filePath)
                        guard let data = try? Data(contentsOf: filePath) else { return }
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } else {
            guard let data = try? Data(contentsOf: filePath) else { return }
            completion(.success(data))
        }
    }
}
