//
//  ImageClassifierUseCase.swift
//  Junction
//
//  Created by 송지혁 on 11/17/24.
//

import CoreML
import UIKit

class ImageClassifierUseCase {
    private let model: MobileCLIPImageEncoder
    private lazy var embeddings: [String: [Double]] = self.loadTextEmbeddings()
    
    init() {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .all
        self.model = try! MobileCLIPImageEncoder(configuration: configuration)
    }
    
    private func loadTextEmbeddings() -> [String: [Double]] {
        guard let url = Bundle.main.url(forResource: "text_embeddings", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다.")
            return [:]
        }
        do {
            let data = try Data(contentsOf: url)
            let embeddings = try JSONDecoder().decode([String: [Double]].self, from: data)
            return embeddings
        } catch {
            print("JSON 로드 에러: \(error)")
            return [:]
        }
    }
    
    func classify(image: UIImage) -> String? {
        // 이미지 전처리
        guard let preprocessedImage = preprocessImage(image: image),
              let pixelBuffer = preprocessedImage.toCVPixelBuffer() else {
            print("픽셀 버퍼 생성에 실패했습니다.")
            return nil
        }
        
        // 모델 입력 생성
        guard let input = try? MobileCLIPImageEncoderInput(image: pixelBuffer) else {
            print("모델 입력 생성에 실패했습니다.")
            return nil
        }
        
        // 이미지 임베딩 추출
        guard let output = try? model.prediction(input: input) else {
            print("모델 예측에 실패했습니다.")
            return nil
        }
        
        // 이미지 임베딩을 배열로 변환
        let imageEmbeddingArray = output.var_2233.toArray()
        
        // 유사도 계산
        var logits: [Double] = []
        var labels: [String] = []
        
        for (label, vector) in embeddings {
            // 벡터 길이 확인
            guard vector.count == imageEmbeddingArray.count else {
                print("벡터 길이가 일치하지 않습니다: \(label)")
                continue
            }
            
            // 코사인 유사도 계산 (이미지 임베딩과 텍스트 임베딩은 이미 정규화되었다고 가정)
            let similarity = zip(imageEmbeddingArray, vector).map(*).reduce(0, +)
            
            // 스케일링된 유사도 값 저장
            logits.append(similarity * 100.0) // 스케일링 팩터 적용
            labels.append(label)
        }
        
        // 소프트맥스 적용하여 확률 계산
        let expLogits = logits.map { exp($0) }
        let sumExpLogits = expLogits.reduce(0, +)
        let probabilities = expLogits.map { $0 / sumExpLogits }
        
        // 레이블과 확률을 함께 묶음
        let labelProbabilities = zip(labels, probabilities)
        
        // 각 레이블과 확률 출력
        for (label, probability) in labelProbabilities {
            print("레이블: \(label), 확률: \(probability)")
        }
        
        // 최고 확률을 가진 레이블 찾기
        if let maxProbability = probabilities.max(), let index = probabilities.firstIndex(of: maxProbability) {
            let bestLabel = labels[index]
            print("베스트 레이블: \(bestLabel), 확률: \(maxProbability)")
            
            // 신뢰도 기준에 따라 결과 반환
            let confidenceThreshold = 0.4
            if maxProbability >= confidenceThreshold {
                return bestLabel
            } else {
                print("신뢰도가 충분하지 않습니다: \(maxProbability)")
                return nil
            }
        } else {
            print("레이블을 결정할 수 없습니다.")
            return nil
        }
    }
    
    private func preprocessImage(image: UIImage) -> UIImage? {
        // 이미지 크기 조정 (짧은 변을 256으로 맞춤)
        guard let resizedImage = image.resizeMaintainingAspectRatio(toShortEdge: 256) else {
            print("이미지 리사이즈에 실패했습니다.")
            return nil
        }
        
        // 중앙을 256x256으로 크롭
        guard let croppedImage = resizedImage.centerCrop(to: CGSize(width: 256, height: 256)) else {
            print("이미지 크롭에 실패했습니다.")
            return nil
        }
        
        return croppedImage
    }
}

// MLMultiArray를 [Double]로 변환하는 확장
extension MLMultiArray {
    func toArray() -> [Double] {
        let count = self.count
        var array = [Double](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = self[i].doubleValue
        }
        return array
    }
}

// UIImage 확장 (이미지 전처리)
extension UIImage {
    func resizeMaintainingAspectRatio(toShortEdge shortEdge: CGFloat) -> UIImage? {
        let aspectRatio = size.width / size.height
        let newSize: CGSize
        if size.width < size.height {
            newSize = CGSize(width: shortEdge, height: shortEdge / aspectRatio)
        } else {
            newSize = CGSize(width: shortEdge * aspectRatio, height: shortEdge / aspectRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func centerCrop(to size: CGSize) -> UIImage? {
        let x = (self.size.width - size.width) / 2.0
        let y = (self.size.height - size.height) / 2.0
        let cropRect = CGRect(x: x, y: y, width: size.width, height: size.height).integral
        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let width = Int(size.width)
        let height = Int(size.height)
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_32BGRA,
                                         attrs,
                                         &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        defer { CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0)) }
        
        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return nil
        }
        
        // 이미지 그리기
        UIGraphicsPushContext(context)
        draw(in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        UIGraphicsPopContext()
        
        return buffer
    }
}
