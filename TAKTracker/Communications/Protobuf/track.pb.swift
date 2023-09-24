// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: track.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// All items are required unless otherwise noted!
/// "required" means if they are missing on send, the conversion
/// to the message format will be rejected and fall back to opaque
/// XML representation
struct Atakmap_Commoncommo_Protobuf_V1_Track {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// speed=
  var speed: Double = 0

  /// course=
  var course: Double = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Atakmap_Commoncommo_Protobuf_V1_Track: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "atakmap.commoncommo.protobuf.v1"

extension Atakmap_Commoncommo_Protobuf_V1_Track: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Track"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "speed"),
    2: .same(proto: "course"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularDoubleField(value: &self.speed) }()
      case 2: try { try decoder.decodeSingularDoubleField(value: &self.course) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.speed != 0 {
      try visitor.visitSingularDoubleField(value: self.speed, fieldNumber: 1)
    }
    if self.course != 0 {
      try visitor.visitSingularDoubleField(value: self.course, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Atakmap_Commoncommo_Protobuf_V1_Track, rhs: Atakmap_Commoncommo_Protobuf_V1_Track) -> Bool {
    if lhs.speed != rhs.speed {return false}
    if lhs.course != rhs.course {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
