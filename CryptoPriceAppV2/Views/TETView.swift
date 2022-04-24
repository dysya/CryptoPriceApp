//
//  TETView.swift
//  CryptoPriceAppV2
//
//  Created by dan4 on 23.04.2022.
//

import UIKit
import SnapKit
import Charts

class TETView: UIViewController, ChartViewDelegate{
    
    private var tetLineChart = LineChartView()
    private var dataTask = DataTask()
    private lazy var tetCoinLabel = UILabel()
    private lazy var tetPriceLabel = UILabel()
    private let nameLabel = UILabel()
    private let stepForward = UIButton()
    private let stepBackward = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tetLineChart.delegate = self
        view.backgroundColor = .systemGroupedBackground
        initialize()
    }
    
    private func initialize() {
        
        view.addSubview(nameLabel)
        nameLabel.text = "TETHER price"
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
        
        view.addSubview(stepForward)
        stepForward.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        stepForward.addTarget(self, action: #selector(forwardStep), for: .touchUpInside)
        stepForward.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(50)
        }
        
        view.addSubview(tetCoinLabel)
        tetCoinLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(nameLabel).inset(40)
        }
        
        view.addSubview(tetPriceLabel)
        tetPriceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(tetCoinLabel).inset(20)
        }

        updateData()
        updateLine()
        
    }

    func updateLine() {
        tetLineChart.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
        tetLineChart.center = view.center
        view.addSubview(tetLineChart)
        var entries = [ChartDataEntry]()
        
        var i = 0
        for x in dataTask.tetPriceArray {
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
        
        tetLineChart.xAxis.labelPosition = .bothSided
        tetLineChart.data = data
        
    }
    
    @objc private func forwardStep() {
        let settingsVC = BNBView()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true)
        updateData()
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
            self.tetCoinLabel.text = coin[2].name
            self.tetPriceLabel.text = "\(coin[2].currentPrice) $"
            print(self.tetPriceLabel.text!)
        }
    }
    
}
