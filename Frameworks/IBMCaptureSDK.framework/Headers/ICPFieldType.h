//
//  ICPFieldType.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import "ICPObjectType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ICPFieldTypeStatus) {
    ICPFieldTypeStatusAvailable = 0,
    ICPFieldTypeStatusHidden = -1,
    ICPFieldTypeStatusForbidden = -2
};

/** The ICPFieldType protocol represents the type of a field. */
@protocol ICPFieldType <ICPObjectType>

@property (nonatomic, assign, readonly) ICPFieldTypeStatus status;

/** The label of the Field type */
@property (nonatomic, strong, readonly) NSString *displayName;

@end

NS_ASSUME_NONNULL_END
