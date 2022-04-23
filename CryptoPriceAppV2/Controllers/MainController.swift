//
//  MainCOntroller.swift
//  CryptoPriceAppV2
//
//  Created by dan4 on 19.04.2022.
//

import UIKit
import Alamofire

final class DataTask: ObservableObject {
    
    var coin: Coins?
    var btcPriceArray: [Double] = []
    var ethPriceArray: [Double] = []
    var tetPriceArray: [Double] = []
    var bnbPriceArray: [Double] = []
    
    @objc func loadD(complition: @escaping ()->()) {
            let req = AF.request("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&sparkline=true&price_change_percentage=24h")
            
            req.responseDecodable(of: Coins.self) { [weak self] (response) in
                guard let finDat = response.value else { return }
                DispatchQueue.main.async {
                    self?.coin = finDat
                    self?.btcPriceArray = self?.coin?[0].sparklineIn7D.price ?? []
                    self?.ethPriceArray = self?.coin?[1].sparklineIn7D.price ?? []
                    self?.tetPriceArray = self?.coin?[2].sparklineIn7D.price ?? []
                    self?.bnbPriceArray = self?.coin?[3].sparklineIn7D.price ?? []
                    complition()
                }
            }
            
        }
    
}
