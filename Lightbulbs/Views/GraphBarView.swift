//
//  GraphBarVIew.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit


class GraphBarView: UIView {
    //view setup
    var barView: UIView = {
        let view = UIView()
        view.addCorners(5).setColor(.gray).done()
        return view
    }()
    
    var innerBarView: UIView = {
        let view = UIView()
        view.addCorners(5).setColor(.green).done()
        return view
    }()
    
    var bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "?"
        label.setFont(name: "Futura", size: 15).done()
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "?"
        label.setFont(name: "Futura", size: 18).done()
        return label
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
        nameLabel.setSuperview(self)
            .addBottom()
            .addLeading()
            .addTrailing()
            .addHeight(withConstant: 25).done()
       
        bottomLabel.setSuperview(self)
            .addBottom(anchor: nameLabel.topAnchor, constant: -5)
            .addLeading().addTrailing()
            .addHeight(withConstant: 20).done()
        
        barView.setSuperview(self)
            .addTop().addCenterX()
            .addWidth(withConstant: 20)
            .addBottom(anchor: bottomLabel.topAnchor, constant: -10).done()
        
        innerBarView.setSuperview(barView)
            .addBottom()
            .addLeading()
            .addTrailing()
            .addHeight(withConstant: 10).done()
      

    }
}
