//
//  ViewController.swift
//  RectangleApp
//
//  Created by Laura Bejan on 10.08.2021.
//


import UIKit

class ViewController: UIViewController {

    var randomSize: CGSize {
        CGSize(width: Int.random(in: 30...200),
               height: Int.random(in: 30...200))
    }

    // UI Setup
    lazy var sliderView: UISlider = {
        let slider = UISlider()

        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.tintColor = UIColor.green
        slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: .valueChanged)

        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            slider.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            slider.heightAnchor.constraint(equalToConstant: view.frame.height * 0.1),
        ])

        return slider
    }()

    lazy var sliderHueLabel = UILabel()

    lazy var tapOutsideLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap outside the yellow view to close the slider"
        return label
    }()

    var isInfoMessageVisible: Bool {
        !yellowStackView.isHidden
    }

    var selectedRectangle: Rectangle?

    lazy var yellowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tapOutsideLabel, sliderHueLabel])

        stackView.backgroundColor = .yellow
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isHidden = true

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 300),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 700),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -300),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -600)
        ])

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleViewTap(_:)))
        view.addGestureRecognizer(tap)
    }
}

// MARK: Gesture Handlers
private extension ViewController {
    @objc func handleViewTap(_ sender: UITapGestureRecognizer?) {
        guard let tapGesture = sender else { return }

        if isInfoMessageVisible {
            setupSliderUI(isHidden: true)
        } else {
            if tapGesture.state == UIGestureRecognizer.State.recognized {
                createRectangle(with: tapGesture.location(in: tapGesture.view))
            }
        }
    }

    @objc func handleRectanglePan(_ sender: UIPanGestureRecognizer? = nil) {
        guard let sender = sender, let pannedView = sender.view else { return }

        let translation = sender.translation(in: view)
        pannedView.center = CGPoint(x: pannedView.center.x + translation.x, y: pannedView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }

    @objc func handleRectangleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let tapGesture = sender,
              let tappedRectangle = tapGesture.view as? Rectangle else {
            return
        }

        if yellowStackView.isHidden {
            view.bringSubviewToFront(yellowStackView)
            view.bringSubviewToFront(sliderView)
        }

        selectedRectangle = tappedRectangle
        sliderHueLabel.text = "\(tappedRectangle.hue)"
        sliderView.setValue(Float(tappedRectangle.hue), animated: true)

        setupSliderUI(isHidden: false)
    }

    @objc func sliderValueChanged(_ sender: UISlider?) {
        guard let sender = sender else { return }
        sliderHueLabel.text = String(describing: sender.value)
        selectedRectangle?.hue = CGFloat(sender.value)
    }
}

// MARK: Private Helpers
private extension ViewController {
    func createRectangle(with origin: CGPoint) {
        let size = randomSize
        let center = CGPoint(x: origin.x - size.width/2,
                             y: origin.y - size.height/2)
        let rectangle = Rectangle(frame: CGRect(origin: center, size: size))

        self.view.addSubview(rectangle)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRectanglePan(_:)))
        rectangle.addGestureRecognizer(panGesture)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleRectangleTap(_:)))
        rectangle.addGestureRecognizer(tap)
    }

    func setupSliderUI(isHidden: Bool) {
        sliderView.isHidden = isHidden
        yellowStackView.isHidden = isHidden
    }
}
