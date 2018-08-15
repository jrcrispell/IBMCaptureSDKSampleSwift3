//
//  ICPService.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@protocol ICPApplication, ICPSetupDCO, ICPBatchType, ICPBatch;

typedef NS_ENUM(NSUInteger, ICPDatacapServiceProviderType) {
    ICPDatacapServiceProviderTypeUnknown = 0,
    ICPDatacapServiceProviderTypeDatacap = 1,
    ICPDatacapServiceProviderTypeBox = 2
};

/**
 *  The ICPService protocol represents a remote service.
 */
@protocol ICPService <NSObject>

/** The URL of the remote service. */
@property (nonatomic, strong, nullable) NSURL *baseURL;

@property (nonatomic, readonly) ICPDatacapServiceProviderType providerType;

/**
 *  The application
 */
@property (nonatomic, strong, nullable) id<ICPApplication> application;

/** 
 *  The name of the server where the services is hosted
 */
@property (nonatomic, strong, nullable) NSString *provider;

/**
 *  The setupDCO
 */
@property (nonatomic, strong, nullable) id<ICPSetupDCO> setupDCO;

/**
 *  The batch types supported by the service
 */
@property (nonatomic, strong) NSArray<id<ICPBatchType> > *batchTypes;

/**
 *  The batches associated with the service
 */
@property (nonatomic, strong) NSArray<id<ICPBatch> > *batches;

/**
 Adds a batch type to the service.
 @param batchType the batch type to be added to the service.
 */
- (void)addBatchType:(id<ICPBatchType>)batchType;

/**
 Removes a batch type from the service.
 @param batchType the batch type to be removed from the service.
 */
- (void)removeBatchType:(id<ICPBatchType>)batchType;

/**
 Adds a batch to the service.
 @param batch The batch to add to the service.
 */
- (void)addBatch:(id<ICPBatch>)batch;

/**
 Removes a batch from the service.
 @param batch The batch to remove from the service.
 */
- (void)removeBatch:(id<ICPBatch>)batch;

/**
 Reorders batches in the document.
 @param atIndex The index from where the batch should be moved.
 @param toIndex The index to where the batch should be moved.
 */
- (void)moveBatchAtIndex:(NSUInteger)atIndex toIndex:(NSUInteger)toIndex;

/**
 Inserts a batch at the given index.
 @param batch The batch to be inserted.
 @param index The index where the batch should be inserted.
 */
- (void)insertBatch:(id<ICPBatch>)batch atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
