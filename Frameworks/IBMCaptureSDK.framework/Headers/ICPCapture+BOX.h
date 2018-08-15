//
//  ICPCapture+BOX.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import "ICPCapture.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ICPBoxService;

@interface ICPCapture (BOX)

+ (void) configBoxWithClientId:(NSString *)clientId
               andClientSecret:(NSString *)clientSecret;

- (nullable ICPSessionManager*)boxSessionManagerWithService:(id<ICPBoxService>)service;

@end

NS_ASSUME_NONNULL_END
