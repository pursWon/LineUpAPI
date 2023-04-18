import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {
    @IBOutlet weak var lineUpTableView: UITableView!
    
    let url: String = "https://sportscore1.p.rapidapi.com/teams/6/lineups?page=19"
    var members: [FootballData] = []
    var players: [Players] = []
    var startingLineUp: [Players] = []
    var benchLineUp: [Players] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLineUpData(url: url)
        lineUpTableView.delegate = self
        lineUpTableView.dataSource = self
        lineUpTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "customHeader")
    }
    
    func getLineUpData(url: String) {
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": "bd1943e54fmshcf26ec05c02738fp14214cjsnc5537f279a66",
            "X-RapidAPI-Host": "sportscore1.p.rapidapi.com"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: LineUp.self) {
            response in
            if let data = response.value {
                
                for i in data.data {
                    self.members.append(i)
                }
                
                self.players = self.members[0].lineup_players
                
                for i in 0..<11 {
                    self.startingLineUp.append(self.players[i])
                }
                
                for i in 11..<20 {
                    self.benchLineUp.append(self.players[i])
                }
                
                DispatchQueue.main.async {
                    self.lineUpTableView.reloadData()
                }
            } else {
                print("통신 실패")
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return startingLineUp.count
        } else {
            return benchLineUp.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.lineUpTableView.dequeueReusableCell(withIdentifier: "LineUpCell", for: indexPath) as? LineUpCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let starting = startingLineUp[indexPath.row]
            cell.numberLabel.text = String(starting.shirt_number)
            cell.nameLabel.text = starting.player.name
            let imageURL = URL(string: starting.player.photo)
            cell.playerImageView.kf.setImage(with: imageURL)
            
            switch starting.position_name {
            case "Goalkeeper":
                cell.positionLabel.text = "GK"
                cell.backgroundColor = .yellow
            case "Defender":
                cell.positionLabel.text = "DF"
                cell.backgroundColor = .green
            case "Midfielder":
                switch indexPath.row {
                case 4:
                    cell.positionLabel.text = "DF"
                    cell.backgroundColor = .green
                case 7:
                    cell.positionLabel.text = "DF"
                    cell.backgroundColor = .green
                default:
                    cell.positionLabel.text = "MF"
                    cell.backgroundColor = .systemIndigo
                }
            case "Forward":
                cell.positionLabel.text = "FW"
                cell.backgroundColor = .orange
            default:
                print("")
            }
        } else {
            let bench = benchLineUp[indexPath.row]
            cell.numberLabel.text = String(bench.shirt_number)
            cell.nameLabel.text = bench.player.name
            let imageURL = URL(string: bench.player.photo)
            cell.playerImageView.kf.setImage(with: imageURL)
            
            switch bench.position_name {
            case "Goalkeeper":
                cell.positionLabel.text = "GK"
                cell.backgroundColor = .yellow
            case "Defender":
                cell.positionLabel.text = "DF"
                cell.backgroundColor = .green
            case "Midfielder":
                cell.positionLabel.text = "MF"
                cell.backgroundColor = .systemIndigo
            case "Forward":
                cell.positionLabel.text = "FW"
                cell.backgroundColor = .orange
            default:
                print("")
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader")
        let title: [String] = ["선발 라인업", "교체 라인업"]
        
        header?.textLabel?.text = title[section]
        header?.textLabel?.font = .boldSystemFont(ofSize: 25)
        header?.textLabel?.textColor = .black
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
