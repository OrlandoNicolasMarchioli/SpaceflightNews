// JSONDecoder+Extensions.swift

import Foundation

public extension JSONDecoder {
    
    static var snakeCaseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

public extension DecodingError {
    
    var readableDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            return String(format: "DECODING_ERROR_TYPE_MISMATCH".translate, "\(type)", context.debugDescription)
        case .valueNotFound(let type, let context):
            return String(format: "DECODING_ERROR_VALUE_NOT_FOUND".translate, "\(type)", context.debugDescription)
        case .keyNotFound(let key, let context):
            return String(format: "DECODING_ERROR_KEY_NOT_FOUND".translate, key.stringValue, context.debugDescription)
        case .dataCorrupted(let context):
            return String(format: "DECODING_ERROR_DATA_CORRUPTED".translate, context.debugDescription)
        @unknown default:
            return "DECODING_ERROR_UNKNOWN".translate
        }
    }
}
