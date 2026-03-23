//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Ayoola Abimbola on 3/23/26.
//

import SwiftUI

class DownloadImageAsyncImageLoader {
  let url = URL(string: "https://picsum.photos/200")! // Using 'forced unwrap' just for this video

  func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let data = data,
        let image = UIImage(data: data),
        let response = response as? HTTPURLResponse,
        response.statusCode >= 200 && response.statusCode < 300 else {
          completionHandler(nil, error)
          return
        }

      completionHandler(image, nil)
    }
    .resume()
  }
}

@Observable class DownloadImageAsyncViewModel {
  var image: UIImage? = nil

  let loader = DownloadImageAsyncImageLoader()

  func fetchImage() {
//    self.image = UIImage(systemName: "heart.fill")
    loader.downloadWithEscaping { [weak self] image, error in
      DispatchQueue.main.async {
        self?.image = image
      }
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
      viewModel.fetchImage()
    }
  }
}

#Preview {
  DownloadImageAsync()
}
