import Foundation

class URLProtocolMock: URLProtocol {

  static var testURLs = [URL?: Data]()
  static var response: URLResponse?
  static var error: Error?

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    if let url = request.url, let data = URLProtocolMock.testURLs[url] {
      self.client?.urlProtocol(self, didLoad: data)
    }
    
    if let response = URLProtocolMock.response {
      self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    
    if let error = URLProtocolMock.error {
      self.client?.urlProtocol(self, didFailWithError: error)
    } else {
      self.client?.urlProtocolDidFinishLoading(self)
    }
  }

  override func stopLoading() { }
}
