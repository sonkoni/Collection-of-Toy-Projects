//
//  MGUNeoSegModel.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUNeoSegModel.h"

@implementation MGUNeoSegModel
@dynamic isImageAvailable;

- (id)copyWithZone:(NSZone *)zone {
    MGUNeoSegModel *model = [[self.class allocWithZone:zone] init];
    if (model) {
        model->_title = _title;  // 쉘로우 카피
        model->_imageName = _imageName;
        model->_imageUrl = _imageUrl;
    }
    // layoutAttributes->_backgroundColor = [_backgroundColor copyWithZone:zone]; // 딥 카피
    // layoutAttributes->_insets = _insets; 스칼라는 똑같다.
    return model;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
//    if ([super isEqual:object] == NO) { // super 클래스가 - isEqual: 메서드를 구현하지 않았다면 호출금지다.
//        return NO;
//    }
    return [self isEqualToMGUNeoSegModel:(MGUNeoSegModel *)object];
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    // NSUInteger result = [super hash]; super가 NSObject이므로 super를 호출해서는 안된다.
    NSUInteger result = [_title hash];
    result = prime * result + [_imageName hash];
    result = prime * result + [_imageUrl hash];
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, title: %@, imageName: %@, imageUrl: %@>", [self class], self, self.title, self.imageName, self.imageUrl];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithTitle:(NSString * _Nullable)title {
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString * _Nullable)title
                    imageName:(NSString * _Nullable)imageName {
    self = [self initWithTitle:title];
    if (self) {
        _imageName = imageName;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString * _Nullable)title
                     imageUrl:(NSString * _Nullable)imageUrl {
    self = [self initWithTitle:title];
    if (self) {
        if (imageUrl) {
            _imageUrl = [[NSURL alloc] initWithString:imageUrl];
        }
    }
    
    return self;
}

+ (instancetype)segmentModelWithTitle:(NSString * _Nullable)title {
    return [[MGUNeoSegModel alloc] initWithTitle:title];
}

+ (instancetype)segmentModelWithTitle:(NSString * _Nullable)title
                            imageName:(NSString * _Nullable)imageName {
    return [[MGUNeoSegModel alloc] initWithTitle:title imageName:imageName];
}

+ (instancetype)segmentModelWithTitle:(NSString * _Nullable)title
                             imageUrl:(NSString * _Nullable)imageUrl {
    return [[MGUNeoSegModel alloc] initWithTitle:title imageUrl:imageUrl];
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToMGUNeoSegModel:(MGUNeoSegModel *)segmentModel {
    if (self == segmentModel) {
        return YES;
    }

    if (segmentModel == nil) {
        return NO;
    }

    BOOL haveEqualTitle = (!self.title && !segmentModel.title) || [self.title isEqualToString:segmentModel.title];
    BOOL haveEqualImageName =
    (!self.imageName && !segmentModel.imageName) || [self.imageName isEqualToString:segmentModel.imageName];
    BOOL haveEqualImageUrl = (!self.imageUrl && !segmentModel.imageUrl) || [self.imageUrl isEqual:segmentModel.imageUrl];

    return haveEqualTitle && haveEqualImageName && haveEqualImageUrl;
}


#pragma mark - read only getter
- (BOOL)isImageAvailable {
    if (self.imageUrl != nil) {
        return YES;
    }
    
    if (self.imageName != nil && ([self.imageName isEqualToString:@""] == NO)) {
        return YES;
    }
    
    return NO;
}

@end
