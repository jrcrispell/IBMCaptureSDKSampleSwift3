//
//  ICPBoxHelper.h
//  IBMCaptureSDK
//
//  Copyright © 2016 IBM Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ICPBoxItem;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ICPBoxHelperFolderListBlock)(BOOL success, NSString *folderId, NSArray<ICPBoxItem *> *items, NSError * _Nullable error);
typedef void(^ICPBoxHelperDownloadFileBlock)(BOOL success, NSData * _Nullable content, NSError * _Nullable error);
typedef void(^ICPBoxHelperRootLookupBlock)(BOOL success, NSString * _Nullable folderName, NSString * _Nullable folderId, NSError * _Nullable error);
typedef void(^ICPBoxHelperOperationBlock)(BOOL success, NSError * _Nullable error);
typedef void(^ICPBoxHelperProgressBlock)(float progress);
typedef void(^ICPBoxHelperFileUpdateBlock)(BOOL success, NSString * _Nullable fileName, NSString * _Nullable fileId, NSError * _Nullable error);
typedef void(^ICPBoxHelperNavigationBlock)(BOOL success, NSString * _Nullable folderId, NSArray<ICPBoxItem *> *items, NSError * _Nullable error);

/**
 The ICPBoxSDKHelper encapsulate the Box sdk operations 
 */
@interface ICPBoxSDKHelper : NSObject

/**
 The id of the Box root folder
 */
@property (nonatomic, strong) NSString *rootFolderId;

/**
 Shared instance of the ICPBoxSDKHelper.
 
 This helper is configurated with the default BOXContentClient 
 and '<i>DatacapApplications</i>' as root folder name
 
 @return Shared instance of ICPBoxSDKHelper
 */
+ (instancetype) helper;

/**
 The ICPBoxSDKHelper encapsulate the Box sdk operations
 */
- (instancetype) init;

/**
 Grabs the name of the user from the SDK.
 If the user never registered the name, the login information will be used
 */
- (NSString *)userName;

/**
 This method will search for a folder on a given path.
 Once the folder is found, the itens on the folder are listed.
 
 @param folder      Name of the folder that will be searched
 @param folderId    Id of the parent folder where the search will be made
 @param completion  Block that will be called once that the operation is completed
 */
- (void) findFolder:(NSString *)folder
             onPath:(NSString *)folderId
     withCompletion:(ICPBoxHelperRootLookupBlock)completion;

/**
 This method will navigate to a given folder and list all its items
 
 @param folderId    Id of the folder that the items will be listed. If nil, the Box root folder id will be used.
 @param completion  Block that will be called once that the operation is completed
 */
- (void) listItemsOnPathWithId:(NSString * _Nullable)folderId
                withCompletion:(ICPBoxHelperFolderListBlock)completion;

/**
 This method will download the binary content of a specific file
 
 @param fileId      Id of the file that will be downloaded
 @param completion  Block that will be called once that the operation is completed
 */
- (void) downloadFileWithId:(NSString *)fileId
             withCompletion:(ICPBoxHelperDownloadFileBlock)completion;

/**
 This method will create an empty folder on a given folder
 
 @param folderName      Name that will be used to create the folder
 @param parentFolderId  Id of the folder where the desired folder will be created
 @param description     Description of the folder
 @param completion      Block that will be called once that the operation is completed
 */
- (void) createFolderWithName:(NSString *)folderName
         inParentFolderWithId:(NSString *)parentFolderId
              withDescription:(NSString * _Nullable)description
                andCompletion:(ICPBoxHelperNavigationBlock)completion;

- (void)updateFolder:(NSString *)folderId
     withDescription:(NSString * _Nullable)description
       andCompletion:(ICPBoxHelperNavigationBlock)completion;

- (void) createOrUpdateFolderWithName:(NSString *)folderName
                 inParentFolderWithId:(NSString *)parentFolderId
                      withDescription:(NSString * _Nullable)description
                        andCompletion:(ICPBoxHelperNavigationBlock)completion;

/**
 This method will delete a specific folder and all its content
 
 @param folderId    Id of the folder that will be deleted
 @param completion  Block that will be called once that the operation is completed
*/
- (void) deleteFolder:(NSString *)folderId
       withCompletion:(ICPBoxHelperOperationBlock)completion;

/**
 This method will create and upload a file to a specific folder
 
 @param file        NSData with the file content
 @param folder      Folder where the file will be created
 @param name        Name that will be used to create the file
 @param description Description of the file
 @param progress    Block that will be used to show the upload progress
 @param completion  Block that will be called once that the operation is completed
 */
- (void)uploadFile:(NSData *)file
          onFolder:(NSString *)folder
          withName:(NSString *)name
       description:(NSString * _Nullable)description
          progress:(_Nullable ICPBoxHelperProgressBlock)progress
     andCompletion:(ICPBoxHelperFileUpdateBlock)completion;

/**
 This method will update the content of a specific file
 
 @param fileId      Id of the file that will be updated
 @param data        NSData with the new file content
 @param description Description of the file
 @param progress    Block that will be used to show the upload progress
 @param completion  Block that will be called once that the operation is completed
 */
- (void) updateFile:(NSString *)fileId
           withData:(NSData *)data
        description:(NSString * _Nullable)description
           progress:(ICPBoxHelperProgressBlock)progress
      andCompletion:(ICPBoxHelperFileUpdateBlock)completion;

/** Load from the resources the default DCO file */
- (NSData *)defaultSetupDCO;

@end

NS_ASSUME_NONNULL_END
