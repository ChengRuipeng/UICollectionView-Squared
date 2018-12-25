//
//  ViewController.swift
//  UICollectionView Squared
//
//  Created by Richard Witherspoon on 12/25/18.
//  Copyright © 2018 Richard Witherspoon. All rights reserved.
//

import UIKit

class SquaredViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let stackView = UIStackView()
    var sidePadding : CGFloat = 20
    var itemsPerRow : CGFloat = 3
    var itemSize = CGFloat()
    
    private let reuseIdentifier = "customCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(itemsPerRow * itemsPerRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TextLabelCell
        cell.labelView.text = "\(indexPath.row + 1)"
        cell.backgroundColor = .cyan
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let portrait = ((collectionView.frame.width - (sidePadding * (itemsPerRow - 1)) ) / itemsPerRow )
        let landscape = ((collectionView.frame.height - (sidePadding * (itemsPerRow - 1)) ) / itemsPerRow ) - 1
        
        let sizes = [portrait, landscape]
        itemSize = sizes.min()!
        if itemSize < 1{
            return .init(width: 1.0, height: 1.0)
        }
        
        return .init(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellSize = ((collectionView.frame.width - (sidePadding * (itemsPerRow - 1)) ) / itemsPerRow ) - 1
        let portraitSpacing = (collectionView.frame.height - (cellSize * itemsPerRow)) / (itemsPerRow - 1)
        
        let landscapeSpacing = sidePadding
        
        let sizes = [portraitSpacing, landscapeSpacing]
        
        return sizes.max()!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let portraitSpacing = sidePadding
        
        let cellSize = ((collectionView.frame.height - (sidePadding * (itemsPerRow - 1)) ) / itemsPerRow )
        let landscapeSpacing = (collectionView.frame.width - (cellSize * itemsPerRow)) / (itemsPerRow - 1)
        
        let sizes = [portraitSpacing, landscapeSpacing]
        
        return sizes.max()!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TextLabelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor, constant: -sidePadding),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sidePadding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sidePadding),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func squareSliderChanged(sender: UISlider!){
        itemsPerRow = CGFloat(sender.value).rounded()
        collectionView.reloadData()
    }
    
    @objc func paddingSliderChanged(sender: UISlider!){
        sidePadding = CGFloat(sender.value).rounded()
        collectionView.reloadData()
    }
    
    
    func setupStackView(){
        let paddingSlider = UISlider()
        let squareSlider  = UISlider()
        let blankView     = UIView()
        
        paddingSlider.tintColor = .red
        paddingSlider.thumbTintColor = .red
        paddingSlider.maximumValue = Float(UIScreen.main.bounds.width * 0.9)
        paddingSlider.minimumValue = 0
        paddingSlider.value = Float(sidePadding)
        paddingSlider.addTarget(self, action: #selector(paddingSliderChanged), for: .valueChanged)

        squareSlider.tintColor = .blue
        squareSlider.thumbTintColor = .blue
        squareSlider.maximumValue = 40
        squareSlider.minimumValue = 2
        squareSlider.value = Float(itemsPerRow)
        squareSlider.addTarget(self, action: #selector(squareSliderChanged), for: .valueChanged)

        stackView.addArrangedSubview(paddingSlider)
        stackView.addArrangedSubview(blankView)
        stackView.addArrangedSubview(squareSlider)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        let constraints = [
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -sidePadding),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sidePadding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sidePadding),
            ]
        stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupBackgroundColor(){
        self.view.backgroundColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupStackView()
        setupCollectionView()
    }
    
}


class TextLabelCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let labelView : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 300)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupLabel(){
        addSubview(labelView)
        let constraints = [
            labelView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            labelView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            labelView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
