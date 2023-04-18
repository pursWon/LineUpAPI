import Foundation

struct LineUp: Decodable {
    let data: [FootballData]
}

struct FootballData: Decodable {
    let lineup_players: [Players]
}

struct Players: Decodable {
    let shirt_number: Int
    var position_name: String
    let player: Player
}

struct Player: Decodable {
    let name: String
    let photo: String
}
