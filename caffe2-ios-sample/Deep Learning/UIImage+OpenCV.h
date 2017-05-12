//
//  UIImage+OpenCV.h
//  caffe2-ios-sample
//
//  Created by Nutchaphon Rewik on 09/05/2017.
//  Copyright © 2017 FuseCore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OpenCV)

/// The correct input should be in rgb 8UC3 mat
- (instancetype)initWithCVMat:(const cv::Mat&)cvMat;

/// RGBA
- (cv::Mat)cvMatRGBA;

/// BGR
- (cv::Mat)cvMatBGR;

/// Gray Scale
- (cv::Mat)cvMatGray;

@end
