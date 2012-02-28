//
//  EvernoteNoteStoreClient+ALAsset.m
//  RollToEver
//
//  Created by fifnel on 2012/02/26.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "EvernoteNoteStoreClient+ALAsset.h"

#import "EvernoteAuthToken.h"
#import "ALAsset+Resize.h"
#import "NSDataMD5Additions.h"
#import "TTransportException.h"
#import <AssetsLibrary/ALAssetRepresentation.h>


@implementation EvernoteNoteStoreClient (ALAsset)

// ノートのタイトルのフォーマット用
static NSDateFormatter *titleDateFormatter_ = nil;

- (void)createNoteFromAsset:(ALAsset *)asset NotebookGUID:(NSString *)notebookGUID {
    /*
     NSLog(@"date=%@ type=%@ url=%@",
     [asset valueForProperty:ALAssetPropertyDate],
     [asset valueForProperty:ALAssetPropertyType],
     [asset valueForProperty:ALAssetPropertyURLs]
     );
     */
    if (titleDateFormatter_ == nil) {
        titleDateFormatter_ = [[[NSDateFormatter alloc] init] autorelease];
        [titleDateFormatter_ setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    // Rowデータを取得して実際のアップロード処理に投げる
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    NSData *data = [asset resizedImageData:100*100];
    NSDate *date = [asset valueForProperty:ALAssetPropertyDate];
    NSString *filename = [rep filename];
    
    // データを整理してnoteを作る
    EDAMNote *note = [[[EDAMNote alloc] init] autorelease];
    note.title = [titleDateFormatter_ stringFromDate:date];
    note.notebookGuid = notebookGUID;
    
    // Calculating the md5
    NSString *hash = [[[data md5] description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash substringWithRange:NSMakeRange(1, [hash length] - 2)];
    
    // 1) create the data EDAMData using the hash, the size and the data of the image
    EDAMData *imageData = [[[EDAMData alloc] initWithBodyHash:[hash dataUsingEncoding: NSASCIIStringEncoding] size:[data length] body:data] autorelease];
    
    // 2) Create an EDAMResourceAttributes object with other important attributes of the file
    EDAMResourceAttributes *imageAttributes = [[[EDAMResourceAttributes alloc] init] autorelease];
    [imageAttributes setFileName:filename];

    // 3) create an EDAMResource the hold the mime, the data and the attributes
    EDAMResource *imageResource  = [[[EDAMResource alloc] init] autorelease];
    [imageResource setMime:@"image/jpeg"];
    [imageResource setData:imageData];
    [imageResource setAttributes:imageAttributes];

    // We are transforming the resource into a array to attach it to the note
    NSArray *resources = [[NSArray alloc] initWithObjects:imageResource, nil];

    // 最小限のイメージ表示用ENML
    NSString *ENML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n<en-note><en-media type=\"image/jpeg\" hash=\"%@\"/></en-note>", hash];

    // Adding the content & resources to the note
    [note setContent:ENML];
    [note setResources:resources];
    [note setCreated:[date timeIntervalSince1970]*1000];

    // 送信
    @try {
        [self.noteStoreClient createNote:[EvernoteAuthToken sharedInstance].authToken :note];
    }
    @catch (EDAMUserException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error saving note: error code %i", [exception errorCode]];
        NSLog(@"%@", errorMessage);
        @throw exception;
    }
    @catch (TTransportException *exception) {
        @throw exception;
    }
}

@end