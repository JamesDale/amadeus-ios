import Foundation

public typealias AmadeusResponse = (Response?, ResponseError?) -> Void

public func send(verb: String,
                    url: String,
                    headers: [String: String],
                    body: String?,
                    onCompletion: @escaping AmadeusResponse) {

    if let url = URL(string: url) {
        let request = NSMutableURLRequest(url: url)

        request.httpMethod = verb

        if body != nil {
            request.httpBody = body!.data(using: String.Encoding.utf8)
        }

        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        process(request: request, onCompletion: { (response, error) -> Void in
            onCompletion(response, error)
             })
    } else {
        onCompletion(nil, ResponseError.malformedURL)
    }
}

private func process(request: NSMutableURLRequest,
                  onCompletion: @escaping AmadeusResponse) {
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

        var amadeusResponse: Response?
        var amadeusError: ResponseError?

        if let httpResponse = response as? HTTPURLResponse {
            // got a valid HTTP answer
            amadeusResponse = Response(response: httpResponse, data: data!)
            // Error could be either nil (200 OK) or enum value
            amadeusError = amadeusResponse!.getErrorCode()
        } else {
            // no HTTP answer: network problem
            amadeusResponse = nil
            amadeusError = ResponseError.returnedError(error!)
        }
        onCompletion(amadeusResponse, amadeusError)
    })
    task.resume()
}
