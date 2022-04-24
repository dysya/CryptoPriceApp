//
//  BNBView.swift
//  CryptoPriceAppV2
//
//  Created by dan4 on 23.04.2022.
//

import UIKit
import SnapKit
import Charts

class BNBView: UIViewController, ChartViewDelegate{
    
    private var bnbLineChart = LineChartView()
    private var dataTask = DataTask()
    private lazy var bnbCoinLabel = UILabel()
    private lazy var bnbPriceLabel = UILabel()
    private let nameLabel = UILabel()
    private let stepBackward = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bnbLineChart.delegate = self
        view.backgroundColor = .systemGroupedBackground
        initialize()
    }
    
    private func initialize() {
        
        view.addSubview(nameLabel)
        nameLabel.text = "BNB price"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(45)
        }
        
        view.addSubview(stepBackward)
        stepBackward.setImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        stepBackward.addTarget(self, action: #selector(backStep), for: .touchUpInside)
        stepBackward.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(50)
        }
        
        view.addSubview(bnbCoinLabel)
        bnbCoinLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(nameLabel).inset(40)
        }
        
        view.addSubview(bnbPriceLabel)
        bnbPriceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(bnbCoinLabel).inset(20)
        }

        updateData()
        updateLine()
        
    }
    
    func updateLine() {
        bnbLineChart.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
        bnbLineChart.center = view.center
        view.addSubview(bnbLineChart)
        var entries = [ChartDataEntry]()
        
        var i = 0
        for x in dataTask.bnbPriceArray {
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
        
        bnbLineChart.xAxis.labelPosition = .bothSided
        bnbLineChart.data = data
        
    }
    
    @objc private func backStep() {
        dismiss(animated: true)
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
            self.bnbCoinLabel.text = coin[3].name
            self.bnbPriceLabel.text = "\(coin[3].currentPrice) $"
            print(self.bnbPriceLabel.text!)
        }
    }
    
}
