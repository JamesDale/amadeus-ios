import Foundation
import SwiftyJSON

/// A namespaced client for the `v2/shopping/hotel-offers/` endpoints
///
/// Access via the `Amadeus` object
/// ```swift
/// let amadeus = Amadeus(client_id, secret_id)
/// amadeus.shopping.hotelOffers
/// ```
public class HotelOffer{
    
    private var client: Client
    private var hotelId: String
    
    public init(client:Client, hotelId: String) {
        self.client = client
        self.hotelId = hotelId
    }
    
    public func get(data: [String:String], onCompletion: @escaping AmadeusResponse){
        client.getAccessToken(onCompletion: {
            (auth) in
            if auth != "error" {
                let endpoint = "v2/shopping/hotel-offers/" + self.hotelId
                let path = generateURL(client: self.client, path: endpoint, data: data)
                getRequest(path: path, auth: auth, client: self.client, onCompletion: {
                    data,err  in
                    if let error = err {
                        onCompletion(nil,error)
                    }else{
                        onCompletion(data,nil)
                    }
                })
            }else{
                onCompletion(nil,nil)
            }
        })
    }
}
