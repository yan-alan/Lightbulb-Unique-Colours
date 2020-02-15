//
//  RunningViewController.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit

class RunningViewController: UIViewController {
    //variables for managing UI and holding data
    var model: LightbulbParamaters!
    private var actualValueArray: [Int] = []
    
    private var runningView: RunningView?
    private var detailedRunningView: DetailedResultsView!
    private var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //view connection, adds button targets and delegation for collection view setup
        runningView = RunningView()
        runningView?.loadingView.restartButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        runningView?.restartButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        detailedRunningView = runningView?.detailedResults
        detailedRunningView.dismissButton.addTarget(self, action: #selector(shrinkView), for: .touchUpInside)
        collectionView = detailedRunningView.resultsCollection
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GraphCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view = runningView
        
        //tap for the nested DetailedResultsView
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(gesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //runs simulation when view did appear
        runSimulation()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    //MARK: Opening and closing DetailedRunningView
    @objc func shrinkView() {
        //deactivating and adding new constraints
        detailedRunningView.isPresented = false
        detailedRunningView.userDefinedConstraintDict["top"]?.isActive = false
        detailedRunningView.userDefinedConstraintDict["bottom"]?.isActive = false
        detailedRunningView.userDefinedConstraintDict["leading"]?.isActive = false
        detailedRunningView.userDefinedConstraintDict["trailing"]?.isActive = false
        detailedRunningView.addTop(anchor: runningView?.stackView.bottomAnchor, constant: 10).addLeading(constant: 20).addTrailing(constant: -20).addBottomSafe(constant: -10).addCorners(20).done()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        //making sure that the gesture recognizer does nothing when the detailedRunningView is in full presentation
        if(!detailedRunningView.isPresented) {
            if(detailedRunningView.frame.contains(location)) {
                detailedRunningView.isPresented = true
                //constraint work and animation, changes label bottom to match image, image becomes shorter
                self.collectionView.setSuperview(self.detailedRunningView!).addTop(anchor: self.detailedRunningView.lightImageView.bottomAnchor, constant: 0).addLeading(constant: 10).addTrailing(constant: -10).addBottomSafe(constant: -10).done()
                self.collectionView.alpha = 0
                self.detailedRunningView.lightImageView.userDefinedConstraintDict["height"]?.constant = 300
                self.detailedRunningView.bottomLeftLabel.userDefinedConstraintDict["bottom"]?.isActive = false
                self.detailedRunningView.bottomLeftLabel.addBottom(anchor: self.detailedRunningView.lightImageView.bottomAnchor, constant: -10).done()
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                    self.detailedRunningView.transform = CGAffineTransform(translationX: 0, y: -100)
                    self.view.layoutIfNeeded()

                }) { (_) in
                    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                        self.detailedRunningView.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.detailedRunningView.userDefinedConstraintDict["top"]?.isActive = false
                        self.detailedRunningView.userDefinedConstraintDict["bottom"]?.isActive = false
                        self.detailedRunningView.userDefinedConstraintDict["leading"]?.isActive = false
                        self.detailedRunningView.userDefinedConstraintDict["trailing"]?.isActive = false
                        self.detailedRunningView.addConstraints(padding: 0).addCorners(0).done()
                        self.view.layoutIfNeeded()
                    }) { (_) in
                        UIView.animate(withDuration: 0.3) {
                            self.collectionView.alpha = 1
                            self.detailedRunningView.topLeftLabel.text = "Simulation Info"
                            self.detailedRunningView.bottomLeftLabel.text = "Unique Colours over Runs"
                            self.detailedRunningView.dismissButton.isHidden = false
                            self.collectionView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                self.collectionView.reloadData()
                            }

                        }
                        
                    }
                }
            }
        }
    }
    //MARK: Simulation Methods
    private func runSimulation() {
        actualValueArray = []
        var expectedValueArray: [Int] = []
        for _ in 0 ..< 10000 {
            expectedValueArray.append(simulate()) //finds expected by running 10000 times
        }
        var expected = Double(expectedValueArray.reduce(0, +))/Double(expectedValueArray.count)
        expected *= 100
        expected.round()
        expected /= 100 //to round to two decimals, multiply by 100, round, then divide by 100 again
        print("ExpectedSum: \(expected)")
        for _ in 0 ..< model.numberOfSimulations {
            actualValueArray.append(simulate()) //runs actual simulations
        }
        var average = Double(actualValueArray.reduce(0, +))/Double(actualValueArray.count) //sums the array, over number of paths
        average *= 100
        average.round()
        average /= 100 //same rounding idea
        let scale = model.numColours //scale is max height of the graph
                
        UIView.animate(withDuration: 0.2, animations: {
            self.runningView?.loadingView.alpha = 0
        }) { (_) in
            self.runningView?.loadingView.isHidden = true //hides the loading view once this work has completed
        }
        
        detailedRunningView.drawColoredLights(n: Int(average)) //draws lights
        runningView?.graphBarViews[0].innerBarView.userDefinedConstraintDict["height"]?.constant = ((CGFloat(average/Double(scale))) * (runningView?.graphBarViews[0].barView.frame.height)!) //sets the height of the bar graph
        runningView?.graphBarViews[0].bottomLabel.text = "\(average)"
        
        runningView?.graphBarViews[1].innerBarView.userDefinedConstraintDict["height"]?.constant = ((CGFloat(expected/Double(scale))) * (runningView?.graphBarViews[1].barView.frame.height)!)
        runningView?.graphBarViews[1].bottomLabel.text = "\(expected)"
        self.detailedRunningView.secondBottomLeftLabel.text = "Unique Colours Average: \(average)"
    }
    private func simulate() -> Int { //runs one simulation, randomly drawing from the array and figuring out the set count after
        var startingArray: [Int] = []
        for i in 0 ..< model.numColours {
            startingArray.append(contentsOf: Array.init(repeating: i, count: model.numEachColour))
        }
        var colours: Set<Int> = []
        for _ in 0 ..< model.numOfChoices {
            let randomIndex = Int.random(in: 0..<startingArray.count)
            colours.insert(startingArray[randomIndex])
            startingArray.remove(at: randomIndex)
        }
        return colours.count
    }
}

//MARK: Collection View Methods
extension RunningViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actualValueArray.count //returns count of the array
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //casts reusable cell to custom cell
        guard let graphCell = cell as? GraphCollectionViewCell else {
            return cell
        }
        //sets up the height of the graph and the text for that cell
        let score = model.numColours
        graphCell.graphView.innerBarView.userDefinedConstraintDict["height"]?.constant = (CGFloat(Double(actualValueArray[indexPath.item])/Double(score)) * (graphCell.graphView.barView.frame.height))
        graphCell.graphView.bottomLabel.text = "\(actualValueArray[indexPath.item])"
        graphCell.graphView.nameLabel.text = "Run \(indexPath.item)"
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        return graphCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: view.frame.height-390)
    }
    
}
