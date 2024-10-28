//
//  CatboxUploader.swift
//  Nin0chat
//
//  Created by tiramisu on 10/23/24.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

struct CatboxUploader: ViewModifier {
    @Binding var text: String
    @State private var showFilePicker: Bool = false
    @State private var selectedFileURL: URL?
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                showFilePicker = true
            }
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [UTType.image],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let fileURLs):
                    if let fileURL = fileURLs.first {
                        selectedFileURL = fileURL
                        uploadFileToCatbox(fileURL: fileURL)
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
    }
    
    func uploadFileToCatbox(fileURL: URL) {
        let access = fileURL.startAccessingSecurityScopedResource()
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://catbox.moe/user/api.php")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fileData = try? Data(contentsOf: fileURL)
        guard let fileData = fileData else {
            print("Failed to read file data")
            return
        }
        let fileName = fileURL.lastPathComponent
        var body = Data()
        
        // MARK: reqtype
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"reqtype\"\r\n\r\n")
        body.append("fileupload\r\n")
        
        // MARK: file data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: application/octet-stream\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        // MARK: api
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("upload failed: \(error?.localizedDescription ?? "idk")")
                return
            }
            
            if let fileLink = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    text.append("\n![](\(fileLink))")
                }
            }
        }
        
        defer {
            if access {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
        
        task.resume()
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension View {
    func catboxUploader(_ text: Binding<String>) -> some View {
        self.modifier(CatboxUploader(text: text))
    }
}
