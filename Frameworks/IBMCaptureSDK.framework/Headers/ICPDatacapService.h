//
//  ICPDatacapService.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import <IBMCaptureSDK/ICPService.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ICPWorkflow, ICPStation, ICPJob, ICPSetupDCO;

/**
 The ICPDatacapService protcol contains the information required to connect to a remote IBM Datacap application.
 It is used by the ICPServiceClient and the ICPDatacapHelper.

 @see ICPServiceClient
 @see ICPDatacapHelper
 */
@protocol ICPDatacapService <ICPService>

/** Allow invalid certificates. This is usually used in development mode where the certificate is self-signed, else connection
 * will be refused */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/** The username for the remote service */
@property (nonatomic, strong) NSString *username;

/**
 *  The workflow
 */
@property (nonatomic, strong, nullable) id<ICPWorkflow> workflow;

/**
 *  The job
 */
@property (nonatomic, strong, nullable) id<ICPJob> job;

/**
 *  The station
 */
@property (nonatomic, strong, nullable) id<ICPStation> station;

@end

NS_ASSUME_NONNULL_END
