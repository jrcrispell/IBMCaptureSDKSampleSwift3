//
//  ICPParallelEdgeValidator.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPEdgeValidator.h"

@interface ICPParallelEdgeValidator : NSObject

@property (nonatomic, assign) CGFloat rotationAngleAllowance;

- (instancetype) initWithRotationAngleAllowance:(CGFloat)angleAllowance NS_DESIGNATED_INITIALIZER;

@end
