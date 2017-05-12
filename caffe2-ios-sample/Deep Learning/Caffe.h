//
//  Caffe.h
//  caffe2-ios-sample
//
//  Created by Nutchaphon Rewik on 09/05/2017.
//  Copyright © 2017 FuseCore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Prediction;

@interface Caffe : NSObject

- (null_unspecified instancetype)init UNAVAILABLE_ATTRIBUTE;

- (nonnull instancetype) initWithInitNetName:(nonnull NSString *)initNetName
                              predictNetName:(nonnull NSString *)predictNetName;

/// return: sorted array of prediction result
- (nonnull NSArray<Prediction *> *)predictFromImage:(nonnull UIImage *)image;


@end
