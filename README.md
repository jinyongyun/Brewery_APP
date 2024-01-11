# Brewery_APP
맥주 추천 Brewery 앱 (영문판) 🍺

이번에 만들어 볼 앱은 맥주 추천! 브루어리 앱이다. [머니뭐니] 프로젝트에서도 사용해본 적이 있는 URLSession을 이용해서 네트워크 통신을 통해 open API에서 맥주 정보를 받아와 화면에 뿌려줄 것이다.

## URLSession을 이용한 HTTP 통신 알아보기

### OSI(Open Systems Interconnection) 7 layers

컴퓨터 네트워크 시간에 권구인 교수님께 배운 그녀석이다.

![TCP](https://github.com/jinyongyun/Brewery_APP/assets/102133961/8176e8a5-7efb-491a-8903-d25b86121e63)

iOS 개발자인 우리들은 주로 HTTP 통신인 상위 단을 다루고, 

아래로 내려갈 수록 물리적 통신에 가까워진다.

간단하게 말하자면 우리가 편지를 상위 단부터 싸서 보내면 받는 쪽에서는 그걸 하나씩 열어나가면서 최종적으로 가장 안의 내용물을 볼 것이다. 그 과정이라고 생각하면 편하다.

이를 캡슐화와 디캡슐화라고 한다.

자세한 내용은 권구인 교수님의 컴퓨터 네트워크를 들어보자! (**필자는 당당히 컴퓨터 네트워크 A+이다**)

여기서는 우리 앱과 관련있는 application Layer(응용계층)에 대해서 알아보자

응용 계층은 가장 상단에서 사용자와 상호작용하는 계층이다. 통신 기능이 있는 앱은 반드시 이 응용 계층을 구현해야 한다. 그럼 이걸 어떻게 구현하냐 → URL (Uniform Resource Locator) 

URL은 네트워크 상에서 리소스들이 어디있는지 알려주기 위한 규약(주소)이다.

어떤 자원에는 반드시 URL이 매칭된다. 이 응용계층에서 가장 자주 쓸 프로토콜은 바로 HTTP이다.

HTTP Request와 Response를 주고받으며 통신을 하는데, 

Request(요청)은 크게 네 가지 구성요소로 구성된다. Method | URL | Header | Body

 Response(응답) 메세지는 다음과 같이 구성된다. StatusCode | Message | Header | Bod

## URLSession

apple의 Foundation 프레임워크는 URLSession이라는 클래스를 제공한다. iOS를 포함한 애플의 OS 상에서 네트워크를 구축하려면 이 URLSession을 활용해야한다.

URLSession은 HTTP를 포함한 OSI 7 Layers의 프로토콜을 지원하고,

네트워크 인증, 쿠키, 캐쉬 관리 같은 서버와의 데이터 교류 작업 전반을 지원한다.

이 URLSession은 네트워크 데이터 전송과 관련된 task 그룹도 조정하게 된다.

URLSession은 **URL로딩 시스템**(URL을 통해 상호작용하고 표준 인터넷 프로토콜을 사용해 서버와 통신하는 시스템) 을 구현할 수 있도록 하는 객체이다. URLSession은 이러한 URL 로딩 시스템을 바탕으로 사용자나 특정 앱에서 만든 사용자 지정 프로토콜을 사용하여 URL 형태로 식별되는 리소스에 대한 Access를 제공한다. 이러한 데이터 읽기는 비동기 식으로 수행되기 때문에 앱이 응답을 유지하고, 수신데이터 또는 오류가 도착하는 즉시 처리할 수 있다.

URLSession 객체를 만들려면, URLSessionConfiguration 이라는 객체를 사용하게 된다. 

여기서는 캐시 및 쿠키를 사용하는 방법, 셀룰러 네트워크에서 연결을 허용할 지 여부같은 동작을 제어하는 객체를 만든다.

- **URLSession(configuration: .default)**
    - 세션에 추가적 설정 가능, 데이터를 점진적으로 가져오도록 델리게이트 설정하는 등
- **URLSession(configuration: .ephemeral)**
    - 임시세션, cash, cookie 또는 자격증명을 디스크에 쓰지 않고 ‘임시’로 처리
- **URLSession(configuration: .background(withIdentifier: “”))**
    - 백그라운드 세션, 앱이 실행되지 않는 동안에도 백그라운드에서 컨텐츠를 업로드 & 다운로드 가능

이렇게 세션을 구성했다면 선택적으로 URLSessionTask를 만들 수 있다.

Session의 Task라는 건, 세션 내에서 데이터를 서버에 업로드 한 다음

서버로부터 데이터를 검색하는 작업을 만든다. 다음은 URLSessionTask의 하위 클래스들이다.

- **URLSessionDataTask (가장 흔하게 쓰인다!)**
    - NSData 객체를 사용해 데이터를 송수신
- **URLSessionUploadTask**
    - 파일을 전송하고, 앱이 실행되지 않는 동안 백그라운드 업로드를 지원한다
- **URLSessionDownloadTask**
    - 파일 형식 기반으로 데이터를 검색, 앱이 실행되지 않는 동안 백그라운드, 다운로드, 업로드 지원
- **URLSessionStreamTask**
- **URLSessionWebSocketTask**

## URLSession Life Cycle

- URLSession 객체 생성 (세션 속성도 정의)
- Request 객체 생성(URL, Method…)
- URLSessionDataTask 생성
    - (일반적으로 세션 객체가 서버로 요청을 보낸 다음, 응답 받을 때 URL기반 내용들 받아서 handling 하는 역할!)
- URLSessionDataTask 생성
    - (일반적으로 세션 객체가 서버로 요청을 보낸 다음, 응답 받을 때 URL기반 내용들 받아서 handling 하는 역할!)
- 반드시 생성한 Task 객체를 Resume 해줘야한다!!
- 의도한대로 Task 완료되면 수신한 response를 해당 Task객체를 생성할 때 설정한 CompletionHandler 또는 Delegate를 통해 가공하고 앱에 구현한다.

 또 이런 객체를 만들지 않고서도 shared라는 싱글톤을 제공해서 세션에 대한 복잡한 요구사항이 없을 경우엔 shared라는 싱글톤을 이용해 세션을 사용한다.

## PunkAPI 알아보기

해당 링크로 들어가보면 Punk API Version2에 대한 Ducumentation이 나와있다.

[Punk API: Brewdog's DIY Dog as an API](https://punkapi.com/)

Root Endpoint, Authentication, Rate Limits 등에 관한 정보가 나와있다.

우리가 쓰는 API의 경우에는 인증이 필요없고, 

접속 제한은 시간당 3600이상의 request는 제한된다고 쓰여있다.

파라미터는 URL 뒤에 붙여서 전달하고, (get방식) 

전부 다 정보를 한꺼번에 주는 것이 아니라, pagination을 통해 25개씩 전달하고 

파라미터에 해당 페이지 번호를 포함하도록 했다.

그리고 가장 중요한 맥주 정보 받기 URL은 다음과 같다.

## Get Beers

Gets beers from the api, you can apply several filters using url paramaters, the available options are listed below.

```
$ curl https://api.punkapi.com/v2/beers
```

## Get a Single Beer

Gets a beer from the api using the beers id.

```
$ curl https://api.punkapi.com/v2/beers/1
```

## Get Random Beer

Gets a random beer from the API, this takes no paramaters.

```
$ curl https://api.punkapi.com/v2/beers/random
```

## Example Response

All beer endpoints return a json array with a number of beer objects inside.

```
[
  {
    "id": 192,
    "name": "Punk IPA 2007 - 2010",
    "tagline": "Post Modern Classic. Spiky. Tropical. Hoppy.",
    "first_brewed": "04/2007",
    "description": "Our flagship beer that kick started the craft beer revolution. This is James and Martin's original take on an American IPA, subverted with punchy New Zealand hops. Layered with new world hops to create an all-out riot of grapefruit, pineapple and lychee before a spiky, mouth-puckering bitter finish.",
    "image_url": "https://images.punkapi.com/v2/192.png",
    "abv": 6.0,
    "ibu": 60.0,
    "target_fg": 1010.0,
    "target_og": 1056.0,
    "ebc": 17.0,
    "srm": 8.5,
    "ph": 4.4,
    "attenuation_level": 82.14,
    "volume": {
      "value": 20,
      "unit": "liters"
    },
    "boil_volume": {
      "value": 25,
      "unit": "liters"
    },
    "method": {
      "mash_temp": [
        {
          "temp": {
            "value": 65,
            "unit": "celsius"
          },
          "duration": 75
        }
      ],
      "fermentation": {
        "temp": {
          "value": 19.0,
          "unit": "celsius"
        }
      },
      "twist": null
    },
    "ingredients": {
      "malt": [
        {
          "name": "Extra Pale",
          "amount": {
            "value": 5.3,
            "unit": "kilograms"
          }
        }
      ],
      "hops": [
        {
          "name": "Ahtanum",
          "amount": {
            "value": 17.5,
            "unit": "grams"
           },
           "add": "start",
           "attribute": "bitter"
         },
         {
           "name": "Chinook",
           "amount": {
             "value": 15,
             "unit": "grams"
           },
           "add": "start",
           "attribute": "bitter"
         },
         ...
      ],
      "yeast": "Wyeast 1056 - American Ale™"
    },
    "food_pairing": [
      "Spicy carne asada with a pico de gallo sauce",
      "Shredded chicken tacos with a mango chilli lime salsa",
      "Cheesecake with a passion fruit swirl sauce"
    ],
    "brewers_tips": "While it may surprise you, this version of Punk IPA isn't dry hopped but still packs a punch! To make the best of the aroma hops make sure they are fully submerged and add them just before knock out for an intense hop hit.",
    "contributed_by": "Sam Mason <samjbmason>"
  }
]

```

### 구현 과정 중 **GCD**에 대해 알아보는 파트가 있으니, 주의깊게 살펴보시길 바랍니다.

[GCD 알아보기 🚧](https://www.notion.so/GCD-a14aeefcab294a9ba30345d5ea99f36f?pvs=21) 

## 구현과정

## 기본 UI 구성

이번에도 storyboard를 사용하지 않고, UI 구성을 코드로 구현해보려고 한다.

저번 앱에서 했던 대로, storyboard와 기본 viewController 파일을 삭제한다.

base가 될 viewController를 하나 만든다.

BeerListViewController라고 해줬고, UITableViewController 타입으로 해줬다.

그리고 sceneDelegate로 이동해서 우리가 만든 viewController가 나타날 수 있게 설정해준다.

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {return}
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = BeerListViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }
```

<img width="279" alt="스크린샷 2024-01-10 오후 6 48 47" src="https://github.com/jinyongyun/Brewery_APP/assets/102133961/7daa6dd0-1ac1-47f3-b455-549c17fbfee0">

이번에도 저번 앱과 마찬가지로 UI를 쉽게 그리기 위해서 swiftPackageManager 설정을 해줄 것이다. 두가지 오픈 API를 쓸건데 SnapKit과 Kingfisher를 사용할 것이다.

File > Add Package Dependency 를 선택해서 외부 라이브러리를 추가하도록 하자.

아주 쉽게 추가할 수 있다.

각각의 설치 URL은 kingFisher와 SnapKit의 공식 깃헙에 들어가보면 나온다!!

SnapKit과 KingFisher를 설치했다면, 이젠 맥주 entity를 만들 것이다.

PunkAPI 알아보기에서 보았듯이 워낙 많은 정보를 받기 때문에, 여기서 필요한 키만 선언해 줄 것이다.

Beer.swift 파일을 만들어준다.

이번 앱에서는 우리가 다시 서버에 정보를 전달하지 않기 때문에 Codable 중에서도 Encodable 과정이 필요없다. PUNK api 도큐먼트로 가보면 우리가 받아야 할 각각의 파라미터에 대한 타입들이 나와있다.

여길 참조하여 Beer 구조체를 만들어보자.

못 받을 수도 있으니 값들은 전부 옵셔널로 설정했다.

```swift
import Foundation

struct Beer: Decodable {
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodParing: [String]?
    
    //taglineString이 자연스러운 태그 형태로 나오도록 설정
    // 원래는 Classic. Spiky. Tropical. Hoppy.
    var tagLine: String {
        let tags = taglineString?.components(separatedBy: ". ")
        let hashtags = tags?.map {
            "#" + $0.replacingOccurrences(of: " ", with: "") //해시태그 추가하고 띄어쓰기 없애
                .replacingOccurrences(of: ".", with: "") // 만약 점 남아있음 없애
                .replacingOccurrences(of: ",", with: " #") //만약 쉼표가 있다면 해시태그로 바꿔
        }
        return hashtags?.joined(separator: " ") ?? "" // 배열을 하나의 스트링으로 합침 - 띄어쓰기 붙여서
    }
    
    enum CodingKeys: String, CodingKey { //우리가 설정한 파라미터 이름과 실제로 받는 이름 달라서...
        case id, name, description
        case taglineString = "tagline"
        case imageURL = "image_url"
        case brewersTips = "brewers_tips"
        case foodParing = "food_paring"
    }
    
}
```

Beer 구조체가 완성되었으니, 

이제 본격적으로 BeerListViewController로 돌아가서 UI를 설정해 볼 것이다. 

먼저 viewDidLoad에 네비게이션 설정을 해 줄 것이다. (네비게이션 바를 커스텀 해 줄 것이다)

```swift
//  BeerListViewController.swift
//  Brewery
//
//  Created by jinyong yun on 1/10/24.
//

import UIKit
import SwiftUI

class BeerListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "Brewery Master"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
}
```

간단하게 제목만 크게 설정해줬다.

그러고 UITableViewController의 DataSource를 설정해야한다.

**var** beerList = [Beer]()
단순하게 다음과 같은 Beer 배열에 데이터를 가져오도록 하고, extension을 통해 DataSource를 설정해주자

```swift
//UITableView DataSource, Delegate
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
}
```

일단은 간단하게 numberOfRowsInSection 메서드에 앞에서 만들어줬던 beerList 배열의 개수만큼 보여주도록 설정했다.

이제 tableView에 맞는 커스텀한 Cell을 만들어줘보자.

파일 이름은 BeerListCell.swift 로 설정하고, 타입은 UITableViewCell로 해줬다.

```swift
//  BeerListCell.swift
//  Brewery
//
//  Created by jinyong yun on 1/10/24.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell {
    
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, taglineLabel].forEach { //contentView의 subView에 추가
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFill
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemBrown
        taglineLabel.numberOfLines = 0
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageView.snp.centerY) //라벨 가운데 = 이미지 가운데
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
    }
    
    
    func configure(with beer: Beer) { //외부를 통해 데이터를 전달받을 수 있도록 하는 메서드
        let imageURL = URL(string: beer.imageURL ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "cup.and.saucer.fill"))
        nameLabel.text = beer.name ?? "beer that has no name"
        taglineLabel.text = beer.tagLine
        
        accessoryType = .disclosureIndicator // 꺽쇠모양 포함
        selectionStyle = .none //탭 회색음영 방지
    }
}
```

셀을 완성했다면, 셀을 사용할 BeerListViewController로 가서 셀을 레지스터 해준다.

viewDidLoad에서 UITableView에 register메서드를 사용해 BeerListCell을 등록해주고

extension에서 cellForRowAt을 작성한다. 

```swift
//  BeerListViewController.swift
//  Brewery
//
//  Created by jinyong yun on 1/10/24.
//

import UIKit
import SwiftUI

class BeerListViewController: UITableViewController {
    
    var beerList = [Beer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "Brewery Master"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
    
    }
}

//UITableView DataSource, Delegate
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as! BeerListCell
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
}
```

이젠 테이블 뷰 셀을 선택했을 때 넘어갈 detail 화면을 구성해줘야 한다.

```swift
//
//  BeerDetailViewController.swift
//  Brewery
//
//  Created by jinyong yun on 1/11/24.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = beer?.name ?? "beer that has no name"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension //테이블 뷰가 알아서 받아와
        
        //헤더 설정
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView()
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
        
        tableView.tableHeaderView = headerView
        
    }
    
}

//UITableView DataSource, Delegate
extension BeerDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int { //섹션 개수 4개 필요
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: //음식 추천 섹션만 beer.foodParing.count로!
            return beer?.foodParing?.count ?? 0
        default:
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { //각 섹션의 타이틀
        switch section {
        case 0:
            return "Recommended by the world's best beer bartenders"
        case 1:
            return "Description"
        case 2:
            return "Brewers Tips"
        case 3:
            let numberOfFoodParing = beer?.foodParing?.count ?? 0
            let isFoodParingEmpty = beer?.foodParing?.isEmpty ?? true
            return isFoodParingEmpty ? nil : "Food Paring"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "beer that has no description"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "beer that has no tips"
            return cell
        case 3:
            cell.textLabel?.text = beer?.foodParing?[indexPath.row] ?? ""
            return cell
        default:
            return cell
        }
        
    }

    
}
```

어려운 부분은 없으니 천천히 읽어보면 이해 할 수 있을 것이다.

이 다음엔 BeerListViewController의 셀을 탭할 때마다 BeerDetailViewController가 보여질 수 있도록 연결하면 끝이다. extension 부분에 다음을 추가한다.

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
```

## 맥주 리스트 가져오기

우리는 페이지 단위로 데이터를 가져오기 때문에 BeerListViewController에서

**var** currentPage = 1

현재 페이지를 나타내는 변수를 설정하고 이를 1로 둔다.

그리고 데이터 fetching을 위한 extension을 따로 빼 줄 것이다.

```swift
/Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //GET으로 요청
         
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                    let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            switch response.statusCode {
            case (200...299): //성공
                self.beerList += beers //받아온 beers를 beerList에 넣어주기
                self.currentPage += 1
                
                **DispatchQueue.main.async { // ⭐️ 여기 집중!! 여기 왜 DispatchQueue인지??
                    self.tableView.reloadData()
                }**
            case (400...499): //client error
                print("""
                   ERROR: Client ERROR \(response.statusCode)
                   Response: \(response)
                """)
            case (500...599): //server error
                print("""
                   ERROR: Server ERROR \(response.statusCode)
                   Response: \(response)
                """)
            default:
                print("""
                   ERROR: ERROR \(response.statusCode)
                   Response: \(response)
                """)
            }
            
        }
        dataTask.resume() // 반드시!!! dataTask 실행!! ⚠️
        
    }
}
```

page를 기반으로 불러올거라, 페이지를 매개변수로 설정한 fetchBeer 메서드를 설정한다. PunkAPI에서 제공해준 page기반 URL을 가져와서 request 객체로 만들고, request method는 GET 방식으로 설정한다. 

그 다음은 dataTask를 설정해줘야 하는데, URLSession.shared.dataTask를 이용해서 completionHandler에서 순환참조 방지를 위해 weak self 설정해주고, guard let 문을 통해 에러가 없어야 하고, response를 정상적으로 받아야하고, data를 정상적으로 받아야하고, 받은 data를 정상적으로 decode 했을 때 통과될 수 있도록 해준다.

switch문을 이용해 받은 response의 status에 따라 정상 상태코드면 받아온 beers(디코드 한 거)를 기존에 데이터를 쓰고 있는 beerList에 추가하고 페이지룰 올려주며

나머지 비정상 상태같은 경우 에러를 프린트해줬다.

만들어준 fetchBeer를 viewDidLoad에서 실행시켜주면 된다.

---

실행시키기 전에 궁금한 점이 있을 것이다(아마도)

왜 저기 굳이굳이 DispatchQueue를 사용해서 main 스레드에서 테이블 뷰 리로드를 해준 것일까?

예전에 분명 [**UI 관련된 리로드 작업은 메인 스레드에서 해줘야한다**]는 걸 들은 적은 있지만 상세한 이유는 몰랐다. 만약 이걸 안하고 실행시키면 어떻게 될까??

→ 보라색 에러 : ***UITableViewController.tableView must be used from main thread only***

이는 GCD와 관련되어 있다. 이 GCD라는 녀석에 대해 더 자세하게 알아보자!

## GCD 알아보기 🚧

스레드라는 것은 프로세스 자원을 공유하는 흐름의 단위이다. 기본적으로 한 프로그램은 한 프로세스를 갖고 있고(Main thread), iOS에서는 모든 앱이 이 main thread를 사용할 수 있다.

우리가 빈번하게 사용하는 UIKit의 클래스들은 오직 이 앱의 메인 스레드에서만 실행된다.

즉 기본적인 UI, 그리고 그러한 UI들을 그리고 행동하는 거…이런 것들이 메인 스레드에서만 실행되어야만 한다.

하지만 프로그램 환경에 따라 둘 이상의 스레드를 동시에 실행할수도 있다.

이러한 실행 방식을 멀티 스레드라고 한다. (네트워크 통신에서의 업로드와 다운로드 등에 필요)

하지만 이렇게 스레드 여러 개를 사용한다고 해도, 일의 분배를 제대로 하지 않는다면 어떻게 될까?

메인 스레드에 일이 전부 몰릴 수도 있다. (별도 설정 없으면 대부분의 작업은 메인 스레드 담당)

메인 스레드가 일을 제대로 분배해주지 않는 상사(개발자) 욕을 지근지근 할 것이다.

하지만 우리가 직접 작업 순서를 정해주기는 쉽지 않다. OS단의 scheduler에서 정해준 순서와 우선순위도 있을테고, 앱이 우리 앱만 있는 것도 아니기에…

그래서 나온 것이 바로 ***GCD (Grand Central Dispatch)***이다.

이 GCD는 시스템에서 관리하는 Dispatch 대기열에 작업을 제출해서 (Multicore HW)에서 동시에 코드를 실행할 수 있도록 해준다. 즉 하나의 앱이 여러개의 코어를 효과적으로 사용할 수 있도록 시스템 단에서 자동으로 제어를 해주는 것이다. 우리 앱 뿐만 아니라 시스템 수준에서 실행 중인 모든 앱의 요구를 적절하게 균형을 잡는 역할을 한다. 

이 Dispatch는 DispatchQueue라는 객체를 활용해서 각각의 작업을 제어하게 된다.

DispatchQueue는 앱의 메인 스레드나 백그라운드 스레드에서 순차적으로 또는 동시에 실행되는 작업을 관리하는 객체이다.

DispatchQueue는 앱이 전달한 작업들을 FIFO으로 내보내주는 큐이다.

DispatchQueue에 전달된 작업은 시스템에서 관리하는 스레드 풀(thread pool - 가용 스레드들이 모여있는 공간이라고 생각하자. 자바 프로그래밍 시간에 배웠다. 기억나니?)에서 실행된다.

이렇게 큐를 활용해서 작업 환경을 동기나 비동기 식으로 설정할 수 있다.

- 동기 : DispatchQueue에 작업이 남아있을 경우, 해당 작업이 끝날 때까지 다음 작업 안해!
    - 즉 한 번에 하나의 작업만…
- 비동기: 필요없어! 동시에 진행시켜!!

이렇게 동기, 비동기까지 설정해서 우리가 DispatchQueue의 작업을 추가하면, 

GCD는 작업에 맞는 스레드를 시스템에서 자동적으로 생성하여 실행한다.

해당 작업이 끝나면 스레드는 제거된다.

놀랍게도 URLSession, 즉 네트워크 통신 부분은 내부적으로 이미 백그라운드에서 비동기적으로 작동하게 설계되어있다. 이미 메인 스레드가 아닌 별도의 스레드에서 동작하고 있는 것이다.

```swift
DispatchQueue.main.async {
   self.tableView.reloadData()
}
```

위와 같은 코드는, main 스레드에서 비동기로 동작하도록 하라는 의미이다.

---

> ****Thread 1: "Could not find a storyboard named 'Main' in bundle NSBundle****
> 

시뮬레이터를 실행시켜봤는데 위와 같은 에러가 발생했다.

info.plist 뿐만 아니라 Application 설정의 info에서 **Main storyboard file base name**

**storyboad Name** 이 2개를 반드시 삭제해줘야한다.



https://github.com/jinyongyun/Brewery_APP/assets/102133961/2967c2c2-6661-435d-bb35-884c069083c4


여기서 문제가 있는데, 첫번째 셀의 오토레이아웃이 뭔가 잘못된 것 같고(라벨 안나옴)

상세 화면에서의 food pairing도 안나온다.

```swift
$0.leading.trailing.bottom.equalToSuperview().inset(20)
```

먼저 이부분, BeerListCell에서 beerImageView의 오토레이아웃 설정 부분인데, leading과 trailing과 bottom값을 부모 뷰에 맞추라고 했는데, 이게 아니라 top,bottom,leading을 맞춰야한다.

food pairing 부분은 beer 엔티티 객체부터 pairing이 아니라 paring으로 잘못쓰여있었다….foodPairing으로 수저해주니

다음과 같이 잘 나왔다.

시뮬레이터를 실행시켜보면 잘 작동하는 것을 알 수 있다.

## 맥주 리스트 표시하기

거의 다 작업이 끝났는데, 마지막 하나의 문제가 남았다.

시뮬레이터를 구동시켜 나타난 맥주 테이블 컨트롤러의 테이블 뷰를 계속 아래로 스크롤하다보면

더 이상 내려가지 않고 페이지가 넘어가지 않는 현상이 발생한다.

이걸 구현하기 위해서는 **prefetch**라는 것을 이용해야한다.

pagination에서 prefetching을 쓰려면, 추가적인 Delegate 설정이 필요하다.

BeerListViewController의 viewDidLoad()에서 

```swift
tableView.prefetchDataSource = self
```

델리게이트 선언 해주고, 실제 델리게이트를 구현해준다.

UITableViewDataSourcePrefetching에서는 반드시 구현해야 하는 메서드가 있다. 바로 prefetchRowAt 메서드가 그 주인공인데, 이녀석은 테이블 뷰에서 실제로 화면에 보이지는 않지만 미리 row들을 가져오는 역할을 수행한다. 실제로 cellForRowAt에 print(”ROWs: \()“) 그리고 해당 prefetchRowAt에 (”PREFETCHs: \()”)를 넣어 실행해보면, prefetch된 row가 찍히는 것을 볼 수 있다.

```swift
//prefetching DataSource
extension BeerListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            guard currentPage != 1 else {return} //최초 페이지 로딩은 viewDidLoad에서
            
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }   
    }
}
```

이렇게 하면 페이지 수가 현재 페이지와 동일해졌을 때

즉 25번째 배수의 indexPath가 불려졌을 때 그 다음 페이지에 맥주리스트를 불러오도록 하는 것이다.

다만 이렇게 설정하면 매번 위아래로 스크롤 할 때마다 해당 index에 맥주가 보일 때 계속 fetching이 될텐데, 너무 많은 맥주 목록이 중복되어 보여질 것 아닌가…

그래서 한 번 불려온 page는 다시 불려오지 않도록 task를 조정할 수 있다.

**var** dataTasks = [URLSessionTask]()

전역변수를 선언하고 url을 정의할 때, 하나의 조건을 더 추가해서 검사하는 것이다.

```swift
 //Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
        dataTasks.firstIndex(where: { $0.originalRequest?.url == url}) == nil
        else {return}
        
       ...

        dataTask.resume() // 반드시!!! dataTask 실행!! 👑
        dataTasks.append(dataTask)
        
    }
}
```

바로 해당 url이 포함된 request가 전역변수 dataTasks에 없어야 한다는 것!

다시 말해 이전에 한 번도 이뤄지지 않은 url 요청일 경우에만 fetching을 실행하는 것이다.

따라서 dataTasks에 실행된 dataTask를 추가하는 코드를 마지막에 추가해줬다.

## 실제 구동 화면



https://github.com/jinyongyun/Brewery_APP/assets/102133961/db5b03e6-fed3-4b03-b5bf-2c2be1987f50

