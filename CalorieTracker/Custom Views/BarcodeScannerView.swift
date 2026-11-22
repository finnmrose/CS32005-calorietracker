//
//  BarcodeScannerView.swift
//  CalorieTracker
//
//  Created by Rose on 19/11/2026.
//
//  Adapted from https://levelup.gitconnected.com/i-finally-tried-apple-visionkit-building-a-simple-document-scanner-in-swiftui-c272f0277546
//
//

import VisionKit
import SwiftUI



struct BarcodeScannerView: UIViewControllerRepresentable {
    var onFindBarcode: (RecognizedItem.Barcode) -> Void
    var onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        let scannerViewController = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .fast,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )
        scannerViewController.delegate = context.coordinator
        
        try? scannerViewController.startScanning()
        
        return scannerViewController
    }
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onFindBarcode: onFindBarcode, onCancel: onCancel)
    }
    
    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        private let onFindBarcode: (RecognizedItem.Barcode) -> Void
        private let onCancel: () -> Void
        
        init(onFindBarcode: @escaping (RecognizedItem.Barcode) -> Void, onCancel: @escaping () -> Void) {
            self.onFindBarcode = onFindBarcode
            self.onCancel = onCancel
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .barcode(let code):
                self.onFindBarcode(code)
            default:
                // what how
                // how did you find something that wasnt a barcode
                // its only configured to find barcodes
                {}()
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            dataScanner.stopScanning()
            dataScanner.dismiss(animated: true) {
                self.onCancel()
            }
        }
    }
}
