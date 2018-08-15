//
//  ICPEdgeValidator.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import <CoreGraphics/CGGeometry.h>

@class CIFeature;

@protocol ICPEdgeValidator <NSObject>

- (BOOL) feature:(CIFeature *)feature
isValidforBounds:(CGRect)bounds;

- (BOOL) rect:(CGRect)rect
isValidForBounds:(CGRect)bounds;

@end
