//
//  ImageUploader.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/30.
//

import Firebase
import FirebaseStorage
import UIKit

class ImageUploader {
    static let shared = ImageUploader()

    private let storage = Storage.storage()

    func uploadRecord(image: UIImage? = nil, userEmail: String, roomId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let filename = "\(userEmail)_\(roomId)"
        self.upload(image: image, type: .records, filename: filename) { result in
            completion(result)
        }
    }

    func uploadUser(image: UIImage? = nil, userEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let filename = "\(userEmail)"
        self.upload(image: image, type: .users, filename: filename) { result in
            completion(result)
        }
    }
}

private extension ImageUploader {
    enum Constant {
        static let imageCompressRatio = CGFloat.zero
    }

    enum ImageType: String {
        case users = "gs://escaper-67244.appspot.com/users/"
        case records = "gs://escaper-67244.appspot.com/records/"

        var name: String {
            return String(describing: self)
        }
        var defaultURL: String {
            return self.rawValue + "\(self.name)_default.png"
        }
    }

    func upload(image: UIImage?, type: ImageType, filename: String, completion: @escaping (Result<String, Error>) -> Void) {
        let filePath = "\(type.name)/\(filename)"
        guard let image = image,
              let data = image.jpegData(compressionQuality: Constant.imageCompressRatio) else {
                  completion(.success(type.defaultURL))
                  return
              }
        let storageReference = self.storage.reference()
        let metadata: StorageMetadata = {
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            return metadata
        }()
        storageReference.child(filePath).putData(data, metadata: metadata) { (metadata, error) in
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
