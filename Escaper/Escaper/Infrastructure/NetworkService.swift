//
//  NetworkService.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/11.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func downloadImage(from url: URL, completion: @escaping (Result<URL, NetworkError>) -> Void) {
        URLSession.shared.downloadTask(with: url) { filePath, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse else {
                      completion(.failure(.responseError))
                      return
                  }
            switch response.statusCode {
            case (200..<300):
                guard let filePath = filePath else {
                    completion(.failure(.filePathError))
                    return
                }
                completion(.success(filePath))
            case (300..<400):
                completion(.failure(.clientError))
            case (400..<500):
                completion(.failure(.serverError))
            default:
                break
            }
        }.resume()
    }
}

extension NetworkService {
    enum NetworkError: Error, LocalizedError {
        case clientError
        case serverError
        case decodeError
        case filePathError
        case responseError

        public var errorDescription: String? {
            switch self {
            case .clientError:
                return NSLocalizedString("클라이언트 에러", comment: "Client Error")
            case .serverError:
                return NSLocalizedString("서버 에러", comment: "Server Error")
            case .decodeError:
                return NSLocalizedString("디코드 에러", comment: "Decode Error")
            case .filePathError:
                return NSLocalizedString("파일 경로 에러", comment: "File Path Error")
            case .responseError:
                return NSLocalizedString("응답 에러", comment: "Response Error")
            }
        }
    }
}