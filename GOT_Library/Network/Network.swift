import SwiftUI


final class Network {
    static let shared = Network()
    
    
    private func getJSON<JSON: Codable>(request: URLRequest, type: JSON.Type) async -> Result<JSON, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.invalidResponse)
            }

            if httpResponse.statusCode == 200 {
                do {
                    let decodedJSON = try JSONDecoder().decode(JSON.self, from: data)
                    return .success(decodedJSON)
                } catch {
                    return .failure(error)
                }
            } else {
                return .failure(NetworkError.statusCode(httpResponse.statusCode))
            }
        } catch {
            return .failure(error)
        }
    }

    // Enumeración para representar errores relacionados con la red
    enum NetworkError: Error {
        case invalidResponse
        case statusCode(Int)
    }
    
    func getAllCharacters() async throws -> films {
        do {
            let result = await getJSON(request: .get(url: .getPersonajes), type: films.self)
            
            switch result {
            case .success(let movies):
                return movies
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }

}


public enum HTTPMethods:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum AuthorizationMethod: String {
    case token = "Bearer"
    case basic = "Basic"
}

public extension URLRequest {
    static func get(url:URL, token:String? = nil, authMethod:AuthorizationMethod = .token) -> URLRequest {
        
        var request = URLRequest(url: url)
        if let token {
            request.setValue("\(authMethod.rawValue) \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = HTTPMethods.get.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func post<JSON:Codable>(url: URL,
                                   data: JSON,
                                   method: HTTPMethods = .post,
                                   token: String? = nil,
                                   authMethod: AuthorizationMethod = .token,
                                   encoder: JSONEncoder = JSONEncoder()) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("\(authMethod.rawValue) \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? encoder.encode(data)
        return request
    }
}
