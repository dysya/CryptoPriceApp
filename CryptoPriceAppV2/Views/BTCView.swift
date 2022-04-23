//
//  BTCView.swift
//  CryptoPriceAppV2
//
//  Created by dan4 on 19.04.2022.
//

import UIKit
import SnapKit
import Charts

class MainView: UIViewController, ChartViewDelegate{
    
    private var line = LineChartView()
    private var dataTask = DataTask()
    private lazy var btcCoinLabel = UILabel()
    private lazy var btcPriceLabel = UILabel()
    private let nameLabel = UILabel()
    private let stepForward = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        line.delegate = self
        view.backgroundColor = .systemGroupedBackground
        initialize()
        Timer.scheduledTimer(timeInterval: 80, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    private func initialize() {
        
        view.addSubview(nameLabel)
        nameLabel.text = "BTC price"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(45)
        }
        
        view.addSubview(stepForward)
        stepForward.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        stepForward.addTarget(self, action: #selector(forwardStep), for: .touchUpInside)
        stepForward.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(50)
        }
        
        view.addSubview(btcCoinLabel)
        btcCoinLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(nameLabel).inset(40)
        }
        
        view.addSubview(btcPriceLabel)
        btcPriceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(btcCoinLabel).inset(20)
        }

        updateData()
        updateLine()

        
    }

    func updateLine() {
        
        line.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
        line.center = view.center
        view.addSubview(line)
        var entries = [ChartDataEntry]()
        
        var i = 0
        for x in dataTask.btcPriceArray {
            entries.append(ChartDataEntry(x: Double(i), y: Double(x)))
            i += 1
        }
        
        let set = LineChartDataSet(entries: entries)
        set.drawCirclesEnabled = false
        set.lineWidth = 2.5
        set.mode = .cubicBezier
        set.setColor(.gray)
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = false
        let data = LineChartData(dataSet: set)
        
        line.xAxis.labelPosition = .bothSided
        line.data = data
        
    }
    
    @objc private func forwardStep() {
        let settingsVC = ETHView()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true)
        updateData()
    }
    
    @objc private func updateData() {
        dataTask.loadD{ [weak self] in
            guard let ct = self?.dataTask.coin else { return }
            self?.processCoin(ct)
            self?.updateLine()
        }
    }
    
    private func processCoin(_ coin: Coins) {
        DispatchQueue.main.async {
            self.btcCoinLabel.text = coin[0].name
            self.btcPriceLabel.text = "\(coin[0].currentPrice)$"
            print(self.btcPriceLabel.text!)
        }
    }
    
}
