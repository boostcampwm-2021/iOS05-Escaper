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
    typealias UrlString = String
    typealias URLCompletion = (Result<UrlString, Error>) -> Void
    typealias DataCompletion = (Result<Data, Error>) -> Void

    enum ImageType: String {
        case users
        case records

        var name: String {
            return String(describing: self)
        }
    }

    static let shared = ImageCacheManager()

    private let fileManager = FileManager.default
    private let storage = Storage.storage()
    private let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    private let metadata: StorageMetadata = {
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        return metadata
    }()

    private init() {}

    func uploadRecord(image: UIImage, userEmail: String, roomId: String, completion: @escaping URLCompletion) {
        let filename = "\(userEmail)_\(roomId)"
        self.upload(image: image, type: .records, filename: filename) { result in
            completion(result)
        }
    }

    func uploadUser(image: UIImage, userEmail: String, completion: @escaping URLCompletion) {
        let filename = "\(userEmail)"
        self.upload(image: image, type: .users, filename: filename) { result in
            completion(result)
        }
    }

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

private extension ImageCacheManager {
    func upload(image: UIImage, type: ImageType, filename: String, completion: @escaping (Result<UrlString, Error>) -> Void) {
        let filePath = "\(type.name)/\(filename)"
        guard let data = image.jpegData(compressionQuality: 0.2) else { return }
        let storageReference = self.storage.reference()
        storageReference.child(filePath).putData(data, metadata: self.metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let metadata = metadata,
                      let path = metadata.path else { return }
                completion(.success("gs://\(metadata.bucket)/\(path)"))
            }
        }
    }
}
