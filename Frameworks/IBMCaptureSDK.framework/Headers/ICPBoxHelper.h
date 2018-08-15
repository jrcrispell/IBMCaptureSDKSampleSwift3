//
//  ICPBoxHelper.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPServerHelper.h"
#import "ICPBoxItemType.h"

@class ICPBoxItem;
@protocol ICPObjectFactory, ICPSetupDCO;

NS_ASSUME_NONNULL_BEGIN


typedef void(^ICPBoxHelperSetupDCO)(BOOL success, ICPBoxItem *boxItem, id<ICPSetupDCO> _Nullable setup, NSError * _Nullable error);

typedef void(^ICPBoxHelperListItem)(BOOL success, NSArray<ICPBoxItem *> *items, NSError * _Nullable error);

@interface ICPBoxHelper : NSObject <ICPServerHelper>

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithObjectFactory:(id<ICPObjectFactory>)objectFactory;

- (ICPBoxItem *)rootItem;

- (void) listItemsOfType:(ICPBoxItemType)type
          onFolderWithId:(NSString * _Nullable)folderId
          withCompletion:(ICPBoxHelperListItem)completion;

- (void) setupDCOOnFolderItem:(ICPBoxItem *)boxItem
          withCompletionBlock:(ICPBoxHelperSetupDCO)completion;

@end

NS_ASSUME_NONNULL_END
