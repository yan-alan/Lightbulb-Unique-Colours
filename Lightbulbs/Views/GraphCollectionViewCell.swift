//
//  GraphCollectionViewCell.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-15.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {
    var graphView = GraphBarView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        graphView.setSuperview(self).addConstraints(padding: 0).done()
    }
}
