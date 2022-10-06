//
//  Provider.swift
//  GifSearchApp
//
//  Created by chmini on 2022/09/20.
//

import Foundation

protocol Provider {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E, completion: @escaping (Result<R, Error>) -> Void) where E.Response == R
    
    func request(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class ProviderImpl: Provider {
    
    let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    // endpoint 사용
    func request<R, E>(with endpoint: E, completion: @escaping (Result<R, Error>) -> Void) where R : Decodable, R == E.Response, E : RequestResponsable {
        
        do {
            let urlRequest = try endpoint.makeURLRequest()
            
            session.dataTask(with: urlRequest) { [weak self] data, response, error in
                self?.checkResponse(data: data, response: response, error: error) { result in
                    switch result {
                    case .success(let data):
                        if let decodedData = try? JSONDecoder().decode(R.self, from: data) {
                            completion(.success(decodedData))
                        } else {
                            completion(.failure(NetworkError.decodingError))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
            
        } catch {
            completion(.failure(NetworkError.urlRequestError))
        }
    }
    
    // 그냥 url 사용
    func request(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            self?.checkResponse(data: data, response: response, error: error, completion: { result in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }.resume()
        
    }
    
    private func checkResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            completion(.failure(NetworkError.myError))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.myError))
            return
        }
        
        if let error = error {
            completion(.failure(error))
            return
        }

        completion(.success(data))
    }
}
