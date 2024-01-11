//
//  BeerListViewController.swift
//  Brewery
//
//  Created by jinyong yun on 1/10/24.
//

import UIKit
import SwiftUI

class BeerListViewController: UITableViewController {
    
    var beerList = [Beer]()
    var dataTasks = [URLSessionTask]() //중복 fetching 방지
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "Brewery Master"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        tableView.prefetchDataSource = self // prefetching
    
        fetchBeer(of: currentPage)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
}

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


//Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
        dataTasks.firstIndex(where: { $0.originalRequest?.url == url}) == nil
        else {return}
        
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
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        dataTask.resume() // 반드시!!! dataTask 실행!! 👑
        dataTasks.append(dataTask)
        
    }
}
