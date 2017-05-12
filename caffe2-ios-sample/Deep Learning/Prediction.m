//
//  Prediction.m
//  caffe2-ios-sample
//
//  Created by Nutchaphon Rewik on 10/05/2017.
//  Copyright © 2017 FuseCore. All rights reserved.
//

#import "Prediction.h"

@interface Prediction ()
@property (class, readonly, strong) NSDictionary<NSString *, NSString *> *imageNetClassMap;
@end

@implementation Prediction

- (instancetype)initWithItemName:(NSString *)itemName confidence:(double)confidence {
    if (self = [super init]) {
        self.itemName = itemName;
        self.confidence = confidence;
    }
    return self;
}

+ (NSString *)itemNameForClassIndex:(NSInteger)classIndex {
    NSString *itemName = [self class].imageNetClassMap[@(classIndex).stringValue];
    if (!itemName) {
        return @"Not found";
    }
    return itemName;
}

+ (NSDictionary<NSString *,NSString *> *)imageNetClassMap {
    static NSDictionary *_imageNetClassMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_imageNetClassMap) {
            NSString *jsonPath = [NSBundle.mainBundle pathForResource:@"imagenet_classes" ofType:@"json"];
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            _imageNetClassMap = jsonDict;
        }
    });
    return _imageNetClassMap;
}

@end
