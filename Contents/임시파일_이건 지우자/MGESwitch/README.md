#  Framework


## Dependancy
```
                            
   BaseKit ─┬─ GraphicsKit ─┬─ MacKit + MacRes
            ├─ AudioKit     └─ IosKit + IosRes
            ├─                   └─ WatKit
```
- IosKit/MacKit 은 AudioKit 을 받지 못한다. 주입될 것이다.
- 번들 접근은 BaseKit 의 NSBundle 카테고리에서 제공한다.
- Assets.xcasstes 은 IosRes/MacRes 에 각각 컴파일되어 추가된다.
- WatKit 은 애플워치에서 사용하는 SwiftUI/WatchKit/WatchConnectivity 등을 지원한다.


## Build Setting : Swift Base
```
- Architectures
    * Base SDK              : 택 Automatic / MacOS / iOS / WatchOS
    * Support Platform      : 택 iOS MacOS WatchOS
- Build Option
    * Allow Multi-Platform Build : YES
- Packaging
    * Define Modules        : YES
- Linking
    * Mach-O Type           : Static Library
    * Dead Code Stripping   : YES -- 원래 No 였는데, 애플에서 자꾸 업댓하라고 함..
    * Other Linker Flags     : -ObjC
- Deployment 
    * Skip Install          : YES
    * Strip Debug Symbols During Copy : No (for all setting)
    * Strip Style           : Non-Global Symbols (for all setting)
- User-Defines
    * SWIFT_VERSION         : 5.0
```


## Bundle
```
- Architectures
    * Base SDK              : 택 Mac / iOS
    * Support Platform      : 택 Mac / iOS
- Linking
    * Mach-O Type           : Bundle
```


## Project
```
- General
    * Frameworks, Libraries, and Embedded Content
        : ...Kit.framework          Do Not Embed
        : ...Res.bundle            Embed and Sign
- Build Phases
    * Link Binary With Libraries
        : 의존성 순서로 재배치
    * Copy Bundle Resources
        : Destination    > Resources
        : ...Res.bundle  > code sign on Copy : v
- Build Settings > Linking
    * Dead Code Stripping   : YES
    * Other Linker Flags    : -ObjC 
```


## Pure Objc-Project 라이브러리 링크 에러 문제 해결
킷을 스위프트/오브젝씨 호환 모드로 돌리기 위해 기본 컴파일러를 스위프트로 지정했기 때문에,
순수 오브젝씨 프로젝트에서는 스위프트를 참조해야 킷을 링크할 수 있다.

### 가장 안전한 방법
1. 빈 스위프트 파일 하나를 만든다.
2. 브릿지 헤더 만들 거냐고 물어보면 만든다.

### 순수 objc 프로젝트인데 스위프트 파일이 있는 것이 꼴베기 싫을 때
라이브러리 검색 경로 : Build Settings > Search paths > Library search paths
여기에 다음의 스위프트 라이브러리 경로를 넣어준다. 세 개 다 넣어준다.
```
$(SDKROOT)/usr/lib/swift
$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)
$(TOOLCHAIN_DIR)/usr/lib/swift-5.0/$(PLATFORM_NAME)
```

## Static Library 로 할 경우
### 전체 설정
```
SDKROOT = auto;
SKIP_INSTALL = YES;
STRIP_STYLE = "non-global";
SUPPORTED_PLATFORMS = "iphoneos iphonesimulator macosx watchos watchsimulator";
TARGETED_DEVICE_FAMILY = "1,2,4";
ALLOW_TARGET_PLATFORM_SPECIALIZATION = YES;
OTHER_LDFLAGS = "-ObjC";
MACH_O_TYPE = staticlib;
SWIFT_VERSION = 5.0;
SWIFT_EMIT_LOC_STRINGS = YES;
SWIFT_COMPILATION_MODE = wholemodule;
SWIFT_OPTIMIZATION_LEVEL = "-O";
```

### 스위프트/오브젝씨 모두 적용. 자동 module.modulemap 생성 스크립트
Run Script 추가
- 체크 해제 [ ] Based on dependency analysis
```bash
# 빌드 인클루드에 대표헤더와 모듈맵을 만드는 작업
 mkdir -p ${BUILT_PRODUCTS_DIR}/include/${PRODUCT_NAME}
 cp ${DERIVED_SOURCES_DIR}/${PRODUCT_NAME}-Swift.h ${BUILT_PRODUCTS_DIR}/include/${PRODUCT_NAME}/${PRODUCT_NAME}.h
 echo "module ${PRODUCT_NAME} {\n\tumbrella header \"${PRODUCT_NAME}.h\"\n\texport *\n}" > ${BUILT_PRODUCTS_DIR}/include/${PRODUCT_NAME}/module.modulemap
 ```




## 타켓
```
보통 다음처엄 컴퓨터/모바일 두 분류로 나눠 잡는다

#if TARGET_OS_OSX
#elif TARGET_OS_IPHONE
#endif

애플 기기의 타겟 컨디션 정의
usr/include/TargetConditionals.h

      TARGET_OS_WIN32           - Generated code will run under WIN32 API
      TARGET_OS_WINDOWS         - Generated code will run under Windows
      TARGET_OS_UNIX            - Generated code will run under some Unix (not OSX)
      TARGET_OS_LINUX           - Generated code will run under Linux
      TARGET_OS_MAC             - Generated code will run under Mac OS X variant
         TARGET_OS_OSX          - Generated code will run under OS X devices
         TARGET_OS_IPHONE          - Generated code for firmware, devices, or simulator
            TARGET_OS_IOS             - Generated code will run under iOS
            TARGET_OS_TV              - Generated code will run under Apple TV OS
            TARGET_OS_WATCH           - Generated code will run under Apple Watch OS
            TARGET_OS_BRIDGE          - Generated code will run under Bridge devices
            TARGET_OS_MACCATALYST     - Generated code will run under macOS
         TARGET_OS_DRIVERKIT          - Generated code will run under macOS, iOS, Apple TV OS, or Apple Watch OS
         TARGET_OS_SIMULATOR      - Generated code will run under a simulator
      TARGET_OS_EMBEDDED        - DEPRECATED: Use TARGET_OS_IPHONE and/or TARGET_OS_SIMULATOR instead
      TARGET_IPHONE_SIMULATOR   - DEPRECATED: Same as TARGET_OS_SIMULATOR
      TARGET_OS_NANO            - DEPRECATED: Same as TARGET_OS_WATCH

    +---------------------------------------------------------------------------+
    |                             TARGET_OS_MAC                                 |
    | +-----+ +-------------------------------------------------+ +-----------+ |
    | |     | |                  TARGET_OS_IPHONE               | |           | |
    | |     | | +-----------------+ +----+ +-------+ +--------+ | |           | |
    | |     | | |       IOS       | |    | |       | |        | | |           | |
    | | OSX | | | +-------------+ | | TV | | WATCH | | BRIDGE | | | DRIVERKIT | |
    | |     | | | | MACCATALYST | | |    | |       | |        | | |           | |
    | |     | | | +-------------+ | |    | |       | |        | | |           | |
    | |     | | +-----------------+ +----+ +-------+ +--------+ | |           | |
    | +-----+ +-------------------------------------------------+ +-----------+ |
    +---------------------------------------------------------------------------+
```
