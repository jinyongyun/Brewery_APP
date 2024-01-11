//
//  Beer.swift
//  Brewery
//
//  Created by jinyong yun on 1/10/24.
//

import Foundation

struct Beer: Decodable {
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
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
        case foodPairing = "food_pairing"
    }
    
}
