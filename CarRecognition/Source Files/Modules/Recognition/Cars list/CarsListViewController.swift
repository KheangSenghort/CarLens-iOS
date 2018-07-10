//
//  CarsListViewController.swift
//  CarRecognition
//


import UIKit

internal final class CarsListViewController: TypedViewController<CarsListView>, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Enum describing events that can be triggered by this controller
    ///
    /// - didTapDismiss: send when user want to dismiss the view
    /// - didTapBackButton: send when user taps on the back arrow on screen
    enum Event {
        case didTapDismiss
        case didTapBackButton
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> ())?
    
    /// SeeAlso: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.collectionView.dataSource = self
        customView.collectionView.delegate = self
        customView.collectionView.register(cell: CarListCollectionViewCell.self)
        customView.recognizeButton.addTarget(self, action: #selector(recognizeButtonTapAction), for: .touchUpInside)
        customView.topView.backButton.addTarget(self, action: #selector(backButtonTapAction), for: .touchUpInside)
    }
    
    /// SeeAlso: UIViewController
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateVisibleCells()
        animateProgressView(detectedCars: 3)
    }
    
    @objc private func recognizeButtonTapAction() {
        eventTriggered?(.didTapDismiss)
    }
    
    @objc private func backButtonTapAction() {
        eventTriggered?(.didTapBackButton)
    }
    
    private func animateVisibleCells() {
        let cells = customView.collectionView.visibleCells.compactMap { $0 as? CarListCollectionViewCell }
        cells.forEach {
            if $0.isCurrentlyPrimary {
                $0.invalidateCharts(animated: true)
            } else {
                $0.clearCharts(animated: false)
            }
        }
    }

    private func animateProgressView(detectedCars: Int) {
        // TODO: Replace maximumNumber with real value
        customView.topView.progressView.setup(currentNumber: detectedCars, maximumNumber: 8, invalidateChartInstantly: false)
        customView.topView.progressView.invalidateChart(animated: true)
    }

    /// SeeAlso: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: Replace with the real number
        return 8
    }
    
    /// SeeAlso: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CarListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        // TODO: Replace with getting the element from the model
        let car = LocalCarsDataService().cars.first!
        cell.setup(with: car)
        
        return cell
    }
    
    /// SeeAlso: UICollectionViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateVisibleCells()
    }
}
