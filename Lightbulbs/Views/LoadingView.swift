//
//  LoadingView.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-15.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class LoadingView: UIView {
    var lightBulbs: [ContentFitImageView] =  []
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setFont(name: "Futura", size: 30).done()
        label.text = "Loading..."
        return label
    }()
    lazy var stackView: UIStackView = {
        let hStack = UIStackView()
        hStack.alignment = .fill
        hStack.axis = .horizontal
        hStack.spacing = 1
        hStack.distribution = .fillEqually
        for i in 0 ..< 3 {
            let newView = ContentFitImageView(image: UIImage(systemName: "lightbulb.fill"))
            newView.setImageColor(color: .black)
            lightBulbs.append(newView)
            hStack.addArrangedSubview(newView)
        }
        return hStack
    }()
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        //constraint setup
        stackView.setSuperview(self)
            .addTop()
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addBottom(anchor: centerYAnchor, constant: 0).done()
       
        loadingLabel.setSuperview(self)
            .addBottomSafe(constant: -10)
            .addHeight(withConstant: 40)
            .addLeading(constant: 30)
            .addTrailing(constant: -30).done()
       
        //schedules a timer to switch and scale lights for loading screen
        Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(runLights), userInfo: nil, repeats: true)
    }
    var lightCounter = 0
    @objc func runLights() {
        lightBulbs.forEach({
            $0.setImageColor(color: .black)
        })
        lightBulbs[lightCounter].setImageColor(color: .yellow)
        UIView.animate(withDuration: 0.1, animations: {
            //scales up yellow bulb
            self.lightBulbs[self.lightCounter].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.lightBulbs[self.lightCounter].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (_) in
                self.lightCounter += 1
                
                if(self.lightCounter == 3) {
                    self.lightCounter = 0
                }
            }
        }
        
    }
    
}
