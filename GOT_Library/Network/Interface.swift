import Foundation
let dev = URL(string: "https://thronesapi.com/api/v2")!

extension URL {
    static let baseURL = dev
    
    //MARK: Rutas
    static let getPersonajes = baseURL.appending(path: "Characters")
}


