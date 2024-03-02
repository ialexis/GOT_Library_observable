
import Foundation

/*struct films: Codable {
    let results: [peli]
}
*/
struct Personaje: Codable, Identifiable, Hashable {
    var id = UUID()
    
    let firstName: String
    let lastName: String
    let fullName: String
    let title: String
    let family: String
    let image:  String
    let imageUrl:  String
    
    enum CodingKeys:String, CodingKey {
            case firstName, lastName, fullName, title, family, image, imageUrl
        }
}
