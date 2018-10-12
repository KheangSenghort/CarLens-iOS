//
//  CarRecognizerService.swift
//  CarRecognition
//

import CoreML
import Vision
import UIKit.UIImage

enum TestingModel: Int {
    case one, two, three, four, five, six
    
    var model: MLModel {
        switch self {
        case .one: return CarClassificator_20181011_1556().model
        case .two: return CarClassificator_20181011_1943().model
        case .three: return CarClassifierModel_181011_1212().model
        case .four: return CarClassifierModel_181011_1448().model
        case .five: return CarClassifierModel_181012_0744().model
        case .six: return CarClassifierModel_181012_0807().model
        }
    }
    
    var name: String {
        switch self {
        case .one: return "CarClassificator_20181011_1556"
        case .two: return "CarClassificator_20181011_1943"
        case .three: return "CarClassifierModel_181011_1212"
        case .four: return "CarClassifierModel_181011_1448"
        case .five: return "CarClassifierModel_181012_0744"
        case .six: return "CarClassifierModel_181012_0807"
        }
    }
}

internal final class CarClassificationService {
    
    private let carsDataService: CarsDataService
    
    /// Available states of the service
    enum State {
        case running
        case paused
    }
    
    /// Types of classifications performed by the service.
    enum ClassificationType {
        
        /// Detecting whether object is a car or not.
        case detection
        
        /// Recognizing the concrete model of the car.
        case recognition
        
        /// ML Model for a concrete classification type.
        var model: MLModel {
            switch self {
            case .detection: return CarDetector().model
            case .recognition: return CarRecognizer().model
            }
        }
    }
    
    /// Completion handler for recognized cars
    var completionHandler: (([RecognitionResult]) -> ())?
    
    /// Indicates if recognizer is ready to analyze next frame
    var isReadyForNextFrame: Bool {
        return currentBuffer == nil
    }

    var recognitionModel: MLModel
    
    /// Initializes the object with given parameters
    ///
    /// - Parameter carsDataService: DataService with avialable cars
    init(carsDataService: CarsDataService, recognitionModel: TestingModel) {
        self.carsDataService = carsDataService
        self.recognitionModel = recognitionModel.model
    }
    
    /// Current state of the service
    private(set) var state: State = .running
    
    /// Current type of task to be performed.
    private var type: ClassificationType = .detection
    
    private var currentBuffer: CVPixelBuffer?
    
    private lazy var detectionRequest: VNCoreMLRequest = { [unowned self] in
        return self.request(for: .detection)
    }()
    
    private lazy var recognitionRequest: VNCoreMLRequest = { [unowned self] in
        return self.request(for: .recognition)
    }()
    
    /// Perform ML analyze on given buffer. Will do the analyze only when finished last one.
    ///
    /// - Parameter pixelBuffer: Pixel buffer to be analyzed
    func perform(on pixelBuffer: CVPixelBuffer) {
        guard type == .detection else { return }
        performClassification(on: pixelBuffer)
    }
    
    /// Updates the state of service
    ///
    /// - Parameter state: State to be set
    func set(state: State) {
        self.state = state
    }
    
    private func performClassification(on pixelBuffer: CVPixelBuffer) {
        guard state == .running else { return }
        if type == .detection && !isReadyForNextFrame { return }
        currentBuffer = pixelBuffer
        let orientation = CGImagePropertyOrientation.right
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            var request: VNCoreMLRequest
            switch self.type {
            case .detection:
                request = self.detectionRequest
            case .recognition:
                request = self.recognitionRequest
            }
            try? handler.perform([request])
        }
    }
    
    private func handleResults(request: VNRequest, error: Error?, for type: ClassificationType) {
        guard let results = request.results,
            let classifications = results as? [VNClassificationObservation] else { return }
        switch type {
        case .detection:
            handleDetection(with: classifications)
        case .recognition:
            let recognitionResult = classifications
                .filter { $0.confidence > Constants.Recognition.Threshold.minimum }
                .compactMap { RecognitionResult(label: $0.identifier, confidence: $0.confidence, carsDataService: carsDataService) }
            currentBuffer = nil
            self.type = .detection
            completionHandler?(recognitionResult)
        }
    }
    
    private func handleDetection(with classifications: [VNClassificationObservation]) {
        guard let bestClassification = classifications.max(by: { $0.confidence < $1.confidence }), let buffer = currentBuffer else { return }
        if bestClassification.identifier == Constants.Labels.Detection.notCar {
            guard let bestRecognition = RecognitionResult(label: bestClassification.identifier, confidence: bestClassification.confidence, carsDataService: carsDataService) else { return }
            currentBuffer = nil
            completionHandler?([bestRecognition])
        } else if bestClassification.identifier == Constants.Labels.Detection.car {
            type = .recognition
            performClassification(on: buffer)
        }
    }
    
    private func request(for type: ClassificationType) -> VNCoreMLRequest {
        let mlModel: MLModel
        switch type {
        case .detection: mlModel = type.model
        case .recognition: mlModel = recognitionModel
        }
        guard let model = try? VNCoreMLModel(for: mlModel) else {
            fatalError("Core ML model initialization failed")
        }
        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.handleResults(request: request, error: error, for: type)
        })
        request.imageCropAndScaleOption = .centerCrop
        return request
    }
}
