//
//  ICPBoxItemType.h
//  IBMCaptureSDK
//
//  Copyright © 2016 IBM Corporation. All rights reserved.
//

#ifndef ICPBoxItemType_h
#define ICPBoxItemType_h

/** The possible items retrieved from Box */
typedef NS_ENUM(NSUInteger, ICPBoxItemType) {
    /** Item with undefined type */
    ICPBoxItemTypeUndefined,
    /** Item of type File */
    ICPBoxItemTypeFile,
    /** Item of type Folder */
    ICPBoxItemTypeFolder
};

#endif /* ICPBoxItemType_h */
