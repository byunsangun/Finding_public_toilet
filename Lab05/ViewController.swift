

//
//  ViewController.swift
//  Lab05
//
//  Created by 변상운 on 2020/10/21.
//  Copyright © 2020 sangun. All rights reserved.
//





import UIKit
import CoreLocation
import Alamofire


class ViewController: UIViewController, CLLocationManagerDelegate, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var toiletTableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    var locationManager: CLLocationManager!
    var currentElement = ""
    var toiletItems = [[String : String]]()
    var toiletItem = [String: String]()

    var toiletType = ""
    var toiletName = ""
    var toiletLocationX = ""
    var toiletLocationY = ""
    var toiletDistance = ""
    var toiletAddress = ""
    var toiletTag = ""
    

    var x = 0
    var y = 0
    var myLocationX = 0
    var myLocationY = 0
    
    var blank = false
    var stateOfSearching = false
    var filteredToiletItems: [[String: String]]!
    
    var count = 0
    var rowNumber = 0
    var address = ""
    
    var tagArray: [String : Int] = [:]
    
    let defaults = UserDefaults.standard
    var loginState : Bool = false
    
    struct Welcome: Codable {
        let response: Response?
    }

    struct Response: Codable {
        let result: [result]?
        let service: Service?
        let status: String?
    }
    
    struct Service: Codable {
        let name: String?
        let version: String?
        let operation: String?
        let time: String?
    }

    struct result: Codable {
        let text: String?
        let zipcode: String?
        let structure: Structure
    }

    struct Structure: Codable {
        let level0: String?
        let level1: String?
        let level2: String?
        let level3: String?
        let level4L: String?
        let level4LC: String?
        let level4A: String?
        let level4AC: String?
        let level5: String?
        let detail: String?
    }

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toiletTableView.delegate = self
        toiletTableView.dataSource = self
        searchBar.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        defaults.set(loginState, forKey: "loginState")
        
        // 화장실 정보 API
        let toiletKey = "537a52466e786463313036544f587062"
        let toiletUrl = "http://openAPI.seoul.go.kr:8088/\(toiletKey)/xml/SearchPublicToiletPOIService/1/100/"
        let xmlParser = XMLParser(contentsOf: URL(string: toiletUrl)!)
        xmlParser!.delegate = self
        xmlParser!.parse()
        
        // 거리 값 저장
        for i in 0..<toiletItems.count {
            toiletLocationX = toiletItems[i]["toiletLocationX"]!
            toiletLocationY = toiletItems[i]["toiletLocationY"]!
            toiletItems[i]["toiletDistance"] = gettingDistance(Double(toiletLocationX) ?? 0.0, Double(toiletLocationY) ?? 0.0)
        }
        
        filteredToiletItems = toiletItems
        
        
        // 거리순 정렬
        filteredToiletItems = filteredToiletItems.sorted(by: {$0["toiletDistance"]!.localizedStandardCompare($1["toiletDistance"]!) == .orderedAscending})
        
        
        for i in 0..<filteredToiletItems.count {
            filteredToiletItems[i]["toiletTag"] = String(i)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    
    @IBAction func toiltetReviewButton(_ sender: UIButton) {
        
        let AuthenticationViewController = self.storyboard?.instantiateViewController(identifier: "AuthenticationViewController") as! AuthenticationViewController
        
        print("sender.tag : \(sender.tag)")
        
        AuthenticationViewController.toiletIndexSent = toiletItems[sender.tag]["toiletTag"]!
        
        self.navigationController?.pushViewController(AuthenticationViewController, animated: true)
        
    }
    
    
    
    // 사용자의 위치 표시하려 했으나 시뮬레이터에서 한계 존재
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
        
        // temporary location value
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        // real location value
        let converter: LocationConverter = LocationConverter()
        let (x, y): (Int, Int) = converter.convertGrid(lon: longitude, lat: latitude)
        
        myLocationX = x
        myLocationY = y
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        
        // 지금은 시뮬레이터라서 findLocation 값을 넣음.
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
                //print("(longitude, latitude) = (\(x), \(y))")
                //print("시(도): \(String((address.last?.administrativeArea)!))")
                //print("구(군): \(String((address.last?.locality)!))")
                
                self.currentAddress.text = String((address.last?.administrativeArea)!) + " " + String((address.last?.locality)!)
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredToiletItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toiletTableViewCell", for: indexPath) as! toiletTableViewCell
        
        // 거리순 재정렬
        filteredToiletItems = filteredToiletItems.sorted(by: {$0["toiletDistance"]!.localizedStandardCompare($1["toiletDistance"]!) == .orderedAscending})
        
        toiletItems = toiletItems.sorted(by: {$0["toiletDistance"]!.localizedStandardCompare($1["toiletDistance"]!) == .orderedAscending})
        
        
        for i in 0..<toiletItems.count {
                toiletItems[i]["toiletTag"] = String(i)
        }
        
        
        if(stateOfSearching == false && filteredToiletItems.count == toiletItems.count){
            cell.toiletReviewButton.tag = indexPath.row
        } else {
            print("filteredToiletItems[indexPath.row] : \(filteredToiletItems[indexPath.row]["toiletTag"])")
            cell.toiletReviewButton.tag = Int(filteredToiletItems[indexPath.row]["toiletTag"]!)!
        }
        
        // setting toilet name, type
        cell.toiletName.text = filteredToiletItems[indexPath.row]["toiletName"]
        cell.toiletType.text = filteredToiletItems[indexPath.row]["toiletType"]
        
        // address setting
        gettingAddress(filteredToiletItems[indexPath.row]["toiletLocationX"]!, filteredToiletItems[indexPath.row]["toiletLocationY"]!, cell)
        cell.toiletAddress.text = filteredToiletItems[indexPath.row]["toiletAddress"]
        
        // distance setting
        cell.toiletDistance.text = filteredToiletItems[indexPath.row]["toiletDistance"]! + " km"
        
        count = count + 1
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
////        toiletTableView.deselectRow(at: indexPath, animated: true)
////        rowNumber = indexPath.row
////
////        let AuthenticationViewController = self.storyboard?.instantiateViewController(identifier: "AuthenticationViewController") as! AuthenticationViewController
////        AuthenticationViewController.toiletIndexSent = String(indexPath.row)
////
////
////        self.navigationController?.pushViewController(AuthenticationViewController, animated: true)
//
//    }

    func gettingAddress(_ x: String, _ y: String, _ cell: toiletTableViewCell)  {
        
        let locationKey = "2D36AC81-CA92-3F12-B91A-EC9FEB0782B2"
        let locationUrl = "http://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&format=json&type=road&zipcode=true&simple=false&key=\(locationKey)&point=\(x),\(y)"
        
        var level1 = ""
        var level2 = ""
        var level3 = ""
        var level4L = ""
        var level5 = ""
        
        let doNetwork = AF.request(locationUrl)
        doNetwork.responseJSON { (response) in
            switch response.result {
                
            // 통신 성공
            case .success(let obj):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        let getInstanceData = try JSONDecoder().decode(Welcome.self, from: dataJSON)
                        
                        if(getInstanceData.response?.status == "OK"){
                            
                            // Raw address from API
                            //self.address = getInstanceData.response?.result![0].text ?? ""
                            
                            // Parsing address from API
                            level1 = getInstanceData.response?.result![0].structure.level1 ?? ""
                            level2 = getInstanceData.response?.result![0].structure.level2 ?? ""
                            level3 = getInstanceData.response?.result![0].structure.level3 ?? ""
                            level4L = getInstanceData.response?.result![0].structure.level4L ?? ""
                            level5 = getInstanceData.response?.result![0].structure.level5 ?? ""
                            self.address = level1 + " " + level2 + " " + level3 + " " + level4L + " " + level5
                            
                            cell.toiletAddress.text = self.address
                        }
                        
                        // 화장실이 없어진건지 주소 API에 정보가 없을 때
                        else if(getInstanceData.response?.status == "NOT_FOUND") {
                            cell.toiletAddress.text = "주소 확인 오류"
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                
            // 통신 실패
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    
    
    func gettingDistance(_ toiletX: Double, _ toiletY: Double) -> String {
        
        // real case
        //let firsLocation = CLLocation(latitude: Double(myLocationX), longitude: Double(myLocationY))
        
        // 시뮬레이터 고정 값 설정
        let firsLocation = CLLocation(latitude: 37.480951, longitude: 126.881444)
        let secondLocation = CLLocation(latitude: toiletY, longitude: toiletX)
        
        var distance = firsLocation.distance(from: secondLocation) / 1000
        
        distance = round(distance * 100) / 100
        
        return String(distance)
    }
    
        
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var count = 0
        filteredToiletItems = []
        
        if searchText == "" {
            filteredToiletItems = toiletItems

            stateOfSearching = false
        }
        else {
            for i in toiletItems {
                if i["toiletName"]!.lowercased().contains(searchText.lowercased()) {
                    filteredToiletItems.append(toiletItems[count])
                }
                count = count + 1
                stateOfSearching = true
                
                // 거리순 정렬
                filteredToiletItems = filteredToiletItems.sorted(by: {$0["toiletDistance"]!.localizedStandardCompare($1["toiletDistance"]!) == .orderedAscending})
            }
        }
        self.toiletTableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    // XML 파서가 시작 테그를 만나면 호출됨--------------------------------------------------------------------------------------------
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        //print("elementName : \(elementName)")
        currentElement = elementName
        if (elementName == "row") {
            toiletItem = [String : String]()
            toiletType = ""
            toiletName = ""
            toiletLocationX = ""
            toiletLocationY = ""
            toiletDistance = ""
            toiletTag = ""
        }
        blank = true
    }
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if (currentElement == "FNAME" && blank == true) {
                toiletName = string
        } else if (currentElement == "ANAME" && blank == true) {
                toiletType = string
        } else if( currentElement == "X_WGS84" && blank == true) {
                toiletLocationX = string
        } else if( currentElement == "Y_WGS84" && blank == true) {
                toiletLocationY = string
        }
    }
    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
          
        if (elementName == "row") {
            toiletItem["toiletName"] = toiletName
            toiletItem["toiletType"] = toiletType
            toiletItem["toiletLocationX"] = toiletLocationX
            toiletItem["toiletLocationY"] = toiletLocationY
            toiletItem["toiletDistance"] = ""
            toiletItem["toiletAddress"] = ""
            toiletItem["toiletTag"] = ""
            
            
            toiletItems.append(toiletItem)
        }
        blank = false
    }
    //---------------------------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    func showAlertMessage() {
        let alert = UIAlertController(title: "오류", message: "오류.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
        alert.addAction(defaultAction)
        present(alert,animated: false, completion: nil)
    }
    
    struct MapGridData {
      let re = 6371.00877    // 사용할 지구반경  [ km ]
      let grid = 5.0         // 사용할 지구반경  [ km ]
      let slat1 = 30.0       // 표준위도       [degree]
      let slat2 = 60.0       // 표준위도       [degree]
      let olon = 126.0       // 기준점의 경도   [degree]
      let olat = 38.0        // 기준점의 위도   [degree]
      let xo = 42.0          // 기준점의 X좌표  [격자거리] // 210.0 / grid
      let yo = 135.0         // 기준점의 Y좌표  [격자거리] // 675.0 / grid
    }

    
    class LocationConverter {
        let map: MapGridData = MapGridData()
        
        let PI: Double = .pi
        let DEGRAD: Double = .pi / 180.0
        let RADDEG: Double = 180.0 / .pi
        
        var re: Double
        var slat1: Double
        var slat2: Double
        var olon: Double
        var olat: Double
        var sn: Double
        var sf: Double
        var ro: Double
        
        init() {
            re = map.re / map.grid
            slat1 = map.slat1 * DEGRAD
            slat2 = map.slat2 * DEGRAD
            olon = map.olon * DEGRAD
            olat = map.olat * DEGRAD
            
            sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
            sn = log(cos(slat1) / cos(slat2)) / log(sn)
            sf = tan(PI * 0.25 + slat1 * 0.5)
            sf = pow(sf, sn) * cos(slat1) / sn
            ro = tan(PI * 0.25 + olat * 0.5)
            ro = re * sf / pow(ro, sn)
        }
        
        func convertGrid(lon: Double, lat: Double) -> (Int, Int) {
            
            var ra: Double = tan(PI * 0.25 + lat * DEGRAD * 0.5)
            ra = re * sf / pow(ra, sn)
            var theta: Double = lon * DEGRAD - olon
            
            if theta > PI {
                theta -= 2.0 * PI
            }
            
            if theta < -PI {
                theta += 2.0 * PI
            }
            
            theta *= sn
            
            let x: Double = ra * sin(theta) + map.xo
            let y: Double = ro - ra * cos(theta) + map.yo
            
            return (Int(x + 1.5), Int(y + 1.5))
        }
    }
    
    
    
    
    
    
}


















