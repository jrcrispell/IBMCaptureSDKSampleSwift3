//
//  ICPBoxService.h
//  IBMCaptureSDK
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

#import <IBMCaptureSDK/ICPService.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ICPBoxService <ICPService>

/** The id of the folder where the DCO file is storage and where the job files will be created/uploaded */
@property (nonatomic, strong) NSString *folderId;

/** 
 The parent folder of the folder id.
 Used to try to recreate the path structure, if necessary. 
*/
@property (nonatomic, strong) NSString *parentFolderId;

/** 
 The name of the folder where the DCO file is storage and where the job files will be created/uploaded.
 Used to try to recreate the path structure, if necessary. 
*/
@property (nonatomic, strong) NSString *folderName;

@end

NS_ASSUME_NONNULL_END
