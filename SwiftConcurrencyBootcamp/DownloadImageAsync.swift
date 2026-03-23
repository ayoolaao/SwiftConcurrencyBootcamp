//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Ayoola Abimbola on 3/23/26.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
  let url = URL(string: "https://picsum.photos/200")! // Using 'forced unwrap' just for this video

  func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
    guard
      let data = data,
      let image = UIImage(data: data),
      let response = response as? HTTPURLResponse,
      response.statusCode >= 200 && response.statusCode < 300 else {
//      completionHandler(nil, error)
      return nil
    }

    return image
  }

  // With Escaping
  func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      let image = self?.handleResponse(data: data, response: response)
      completionHandler(image, error)
    }
    .resume()
  }

  // Combine
  func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map(handleResponse)
      .mapError({ $0 })
      .eraseToAnyPublisher()
  }

  // With Async/Await
  func downloadWithAsync() async throws -> UIImage? {
    do {
      let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
      let image = handleResponse(data: data, response: response)

      return image
    } catch {
      throw error
    }

  }
}

@Observable class DownloadImageAsyncViewModel {
  var image: UIImage? = nil

  let loader = DownloadImageAsyncImageLoader()
  var cancellables = Set<AnyCancellable>()

  func fetchImage() async {
    /*
//    self.image = UIImage(systemName: "heart.fill")
//    loader.downloadWithEscaping { [weak self] image, error in
//      DispatchQueue.main.async {
//        self?.image = image
//      }
//    }

//    loader.downloadWithCombine()
//      .receive(on: DispatchQueue.main)
//      .sink { _ in
//        //
//      } receiveValue: { [weak self] image in
//        self?.image = image
//      }
//      .store(in: &cancellables)
     */

    let image = try? await loader.downloadWithAsync()
    await MainActor.run {
      self.image = image
    }
  }
}

struct DownloadImageAsync: View {
  @State private var viewModel = DownloadImageAsyncViewModel()

  var body: some View {
    ZStack {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 250, height: 250)
      }
    }
    .onAppear{
      Task {
        await viewModel.fetchImage()
      }
    }
  }
}

#Preview {
  DownloadImageAsync()
}
