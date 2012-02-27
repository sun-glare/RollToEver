//
//  evernote.h
//  client
//
//  Evernote API sample code is provided under the terms specified in the file LICENSE.txt which was included with this distribution.

// modified by fifnel
//

#import <Foundation/Foundation.h>

#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "UserStore.h"
#import "NoteStore.h"
#import "Errors.h"



extern NSString * const consumerKey;
extern NSString * const consumerSecret;
extern NSString * const userStoreUri;
extern NSString * const noteStoreUriBase;

@interface Evernote : NSObject {
@private
    NSString *username_;
    NSString *password_;

    NSString *authToken;
    EDAMUser *user;

    NSURL *noteStoreUri;
    
    EDAMNoteStoreClient *noteStore;

    NSDateFormatter *titleDateFormatter_;
}

@property(retain) EDAMUser * user;
@property(retain) NSString * shardId; 
@property(retain) NSString * authToken; 
@property(retain) NSURL * noteStoreUri;
@property(retain) EDAMNoteStoreClient *noteStore;
@property(retain) id delegate;

-(id)initWithUserId:(NSString *)username Password:(NSString *)password;

- (void) connect; 

- (NSArray *) listNotebooks;

- (EDAMNoteList *) findNotes: (EDAMNoteFilter *) filter;

- (EDAMNote *) getNote: (NSString *) guid;

- (void) deleteNote: (NSString *) guid;

- (void) createNote: (EDAMNote *) note;

- (void)uploadPhoto:(NSData *)image notebookGUID:(NSString *)notebookGUID date:(NSDate *)date filename:(NSString *)filename;

@end
