//
//  ICPBoxItem.h
//  IBMCaptureSDK
//
//  Copyright © 2016 IBM Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPBoxItemType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The ICPBoxItem model represents a BOX item
 */
@interface ICPBoxItem : NSObject

/** Name of the item */
@property (nonatomic, strong, nonnull, readonly) NSString *name;
/** Id of the model on box */
@property (nonatomic, strong, nonnull, readonly) NSString *itemId;
/** Id of the parent folder of the item on box */
@property (nonatomic, strong, nonnull, readonly) NSString *parentFolderId;
/** The type of the item */
@property (nonatomic, assign, readonly) ICPBoxItemType type;

- (instancetype)init NS_UNAVAILABLE;

/**
 The ICPBoxItem model represents a BOX item
 
 @param name    The name of the item
 @param itemId  The Id of the item on Box
 @param type    The ICPBoxItemType of the item
 */
- (instancetype)initWithName:(NSString *)name
                      itemId:(NSString *)itemId
              parentFolderId:(NSString *)parentFolderId
                     andType:(ICPBoxItemType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
