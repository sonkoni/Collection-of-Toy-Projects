//
//  NSData+HexEncodedString.h
//  RESegmentedControl
//
//  Created by Kwan Hyun Son on 2020/11/14.
//
//! NSData는 description 메소드에서 출력하는 것과 유사한 16진수 문자열로 표시될 수 있다.

#import <Foundation/Foundation.h>
// https://stackoverflow.com/a/40089462
// https://riptutorial.com/ios/example/18979/converting-nsdata-to-hex-string
// https://stackoverflow.com/questions/1305225/best-way-to-serialize-an-nsdata-into-a-hexadeximal-string
// https://stackoverflow.com/questions/16521164/how-can-i-convert-nsdata-to-hex-string
// https://stackoverflow.com/questions/7520615/how-to-convert-an-nsdata-into-an-nsstring-hex-string
// https://stackoverflow.com/questions/13810204/convert-nsdata-length-from-bytes-to-megs

NS_ASSUME_NONNULL_BEGIN

@interface NSData (HexEncodedString)

- (NSString *)mgrHexEncodedString;

@end

@interface NSData (Bundle)

// NSBundle *bundle = [NSBundle bundleForClass:self.class];
//
// NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"bundleName" withExtension:@"bundle"];
// NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
//
// NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
// NSBundle *bundle = [NSBundle bundleWithPath:bundlePath]
+ (nullable instancetype)mgrDataWithBundle:(NSBundle * _Nullable)bundle // nil 이면 main 번들.
                                  fileName:(NSString * _Nullable)fileName
                                    ofType:(NSString * _Nullable)ext;

@end

@interface NSData (Capacity)
#pragma mark - 용량의 표시한다. Bytes, KB, MB
//! 모든 것을 다 표현한다.
- (void)mgrCapacity;  // DEBUG ONLY

// NSByteCountFormatterUseBytes 또는 NSByteCountFormatterUseKB 또는 NSByteCountFormatterUseMB 이 중 하나만 선택하는 것이 좋을듯.
// NSByteCountFormatterCountStyleFile 또는 NSByteCountFormatterCountStyleMemory 둘 중 선택에 선택하라. 단위. 1000 OR 1024
- (void)mgrCapacity:(NSByteCountFormatterUnits)allowedUnits countStyle:(NSByteCountFormatterCountStyle)countStyle;
@end

NS_ASSUME_NONNULL_END
//
// 스위프트 버전.
//extension Data {
//    func hexEncodedString() -> String {
//        return map { String(format: "%02hhx", $0) }.joined()
//    }
//}

// 또는 이것.
//extension NSData {
//    func hexString() -> String {
//        return UnsafeBufferPointer<UInt8>(start: UnsafePointer<UInt8>(bytes), count: length)
//            .reduce("") { $0 + String(format: "%02x", $1) }
//    }
//
//}
