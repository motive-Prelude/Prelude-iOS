//
//  ImageRepository.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import UIKit

protocol ImageRepository {
    func uploadImage(image: UIImage) async throws(DomainError) -> FileUploadResponse
}
