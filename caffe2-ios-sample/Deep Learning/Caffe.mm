//
//  Caffe.m
//  caffe2-ios-sample
//
//  Created by Nutchaphon Rewik on 09/05/2017.
//  Copyright © 2017 FuseCore. All rights reserved.
//

#import "Caffe.h"
#import "Prediction.h"
#import "UIImage+OpenCV.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wconversion"

#import "caffe2/core/predictor.h"
#import "caffe2/utils/proto_utils.h"

#pragma clang diagnostic pop

namespace caffe2 {
    
    void LoadPBFile(NSString *filePath, caffe2::NetDef *net) {
        NSURL *netURL = [NSURL fileURLWithPath:filePath];
        NSData *data = [NSData dataWithContentsOfURL:netURL];
        const void *buffer = data.bytes;
        int len = (int)data.length;
        CAFFE_ENFORCE(net->ParseFromArray(buffer, len));
    }
    
}

@interface Caffe() {
    std::unique_ptr<caffe2::Predictor> _predictor;
}

@end

@implementation Caffe

- (instancetype) initWithInitNetName:(NSString *)initNetName predictNetName:(NSString *)predictNetName {
    self = [super init];
    if (self) {
        NSString *init_net_path = [NSBundle.mainBundle pathForResource:initNetName ofType:@"pb"];
        NSString *predict_net_path = [NSBundle.mainBundle pathForResource:predictNetName ofType:@"pb"];
        
        caffe2::NetDef init_net, predict_net;
        
        caffe2::LoadPBFile(init_net_path, &init_net);
        caffe2::LoadPBFile(predict_net_path, &predict_net);
        
        _predictor = std::make_unique<caffe2::Predictor>(init_net, predict_net);
    }
    return self;
}

- (void)dealloc {
    google::protobuf::ShutdownProtobufLibrary();
}

- (NSArray<Prediction *> *)predictFromImage:(UIImage *)image {
    
    const int numberOfImages = 1;
    const int channels = 3;
    const int predictWidth = 227;
    const int predictHeight = 227;
    const int size = predictHeight * predictWidth;
    
    // Get BGR mat
    cv::Mat mat = [image cvMatBGR];
    
    // Resize mat to predictWidth * predictHeight
    cv::Mat resizedMat;
    cv::resize(mat, resizedMat, cv::Size(predictWidth, predictHeight), 0, 0, cv::INTER_CUBIC);
    
    // Convert memory layout [h][w][c] -> [c][h][w]
    // And translate to 1D vector<float>
    
    // NCHW 1D vector
    std::vector<float> inputPlanar(numberOfImages * channels * predictHeight * predictWidth);
    
    for (auto row = 0; row < predictHeight; ++row) {
        for (auto col = 0; col < predictWidth; ++col) {
            inputPlanar[row * predictWidth + col + 0 * size] = (float) resizedMat.data[(row * predictHeight + col) * 3 + 0];
            inputPlanar[row * predictWidth + col + 1 * size] = (float) resizedMat.data[(row * predictHeight + col) * 3 + 1];
            inputPlanar[row * predictWidth + col + 2 * size] = (float) resizedMat.data[(row * predictHeight + col) * 3 + 2];
        }
    }
    
    // NCHW tensor
    caffe2::TensorCPU input;
    input.Resize(std::vector<int>({ numberOfImages, channels, predictHeight, predictWidth }));
    input.ShareExternalPointer(inputPlanar.data());
    
    caffe2::Predictor::TensorVector input_vec{&input};
    caffe2::Predictor::TensorVector output_vec;
    
    _predictor->run(input_vec, &output_vec);
    
    // Get prediction output
    //
    // output_vec[0] is a tensor that contains 1,000 of prediction results
    // The result's index is ImageNet class index
    //
    NSMutableArray<Prediction *> *results = [NSMutableArray new];
    
    auto output = output_vec[0];
    for (auto index = 0; index < output->size(); index++) {
        auto vals = (const float *)output->raw_data();
        auto val = vals[index];
        NSString *itemName = [Prediction itemNameForClassIndex:index];
        Prediction *prediction = [[Prediction alloc] initWithItemName:itemName confidence:val];
        [results addObject:prediction];
    }

    // Sort result by prediction value
    [results sortUsingComparator:^NSComparisonResult(Prediction * _Nonnull left, Prediction * _Nonnull right) {
        if (left.confidence < right.confidence) {
            return NSOrderedDescending;
        } else if (left.confidence > right.confidence) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return results;
}

@end









