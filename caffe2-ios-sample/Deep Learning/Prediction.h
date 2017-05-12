//
//  Prediction.h
//  caffe2-ios-sample
//
//  Created by Nutchaphon Rewik on 10/05/2017.
//  Copyright © 2017 FuseCore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prediction : NSObject

@property (nonnull, strong) NSString *itemName;
@property (assign) double confidence;

- (nonnull instancetype)initWithItemName:(nonnull NSString *)itemName confidence:(double)confidence;

+ (nonnull NSString *)itemNameForClassIndex:(NSInteger)classIndex;

@end
