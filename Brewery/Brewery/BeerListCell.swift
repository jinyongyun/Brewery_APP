//
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
        
       // contentView.backgroundColor = UIColor(cgColor: <#T##CGColor#>)
        
        [beerImageView, nameLabel, taglineLabel].forEach { //contentView의 subView에 추가
            contentView.addSubview($0)
        }
        
       // beerImageView.contentMode = .scaleAspectFill
        beerImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemBrown
        taglineLabel.numberOfLines = 0
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
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
        beerImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "Beer"))
        nameLabel.text = beer.name ?? "beer that has no name"
        taglineLabel.text = beer.tagLine
        
        accessoryType = .disclosureIndicator // 꺽쇠모양 포함
        selectionStyle = .none //탭 회색음영 방지
    }
}
