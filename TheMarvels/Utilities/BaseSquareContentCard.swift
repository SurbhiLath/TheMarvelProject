//
//  BaseSquareContentCard.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 03/09/22.
//

import UIKit

open class BaseSquareContentCard: UIView {
    var contentView: UIView
    
    var cardCornerRadius: CGFloat = 16.0
    private var shadowLayer: CAShapeLayer!
    
    public init(with contentView: UIView, and frame: CGRect = .zero) {
        self.contentView = contentView
        super.init(frame: frame)
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        self.contentView = UIView()
        super.init(coder: coder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.withAlphaComponent(0.2).cgColor
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 4)
            shadowLayer.shadowOpacity = 0.1
            shadowLayer.shadowRadius = 10
            layer.insertSublayer(shadowLayer, at: 0)
        }
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = cardCornerRadius
    }
    
    private func configureView() {
        addSubview(contentView)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white.withAlphaComponent(0.2)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
