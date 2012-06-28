//
//  MyDocument.h
//  liberdoc
//
//  Created by sergio on 1/2/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LiberPrintPanelController;
@class LiberPrintFormController;

@interface LiberDocument : NSPersistentDocument {
	IBOutlet NSArrayController* _arrayController;
	IBOutlet NSTableView* _tableView;
	IBOutlet NSTextField* _firstTextField;
	IBOutlet NSWindow* _drawerWindow;
	IBOutlet NSImage* _addButtonImage;
	IBOutlet NSTableView* _printView;
	IBOutlet LiberPrintFormController* _liberPrintController;
	IBOutlet LiberPrintPanelController* _liberPrintPanel;
	NSNumber* _currentLiberID;
	BOOL _setUpPrintInfoDefaults;
}
- (void)printShowingPrintPanel:(BOOL)showPanels;
- (IBAction)addNewLiber:(id)sender;
- (NSFont*)currentFont;
- (void)updatePrintView;

/*- (NSNumber *)currentLiberID;
- (void)setCurrentLiberID:(NSNumber *)curLibID;
- (NSNumber *)newCurrentLiberID;
*/

/*
	When a new store is configured (whether for a new untitled document, or when an existing document is reopened), Core Data calls the NSPersistentDocument method configurePersistentStoreCoordinatorForURL:ofType:modelConfiguration:storeOptions:error:. You can override this method to add metadata to a new store before it is saved. */
/*- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url
    ofType:(NSString *)fileType
    modelConfiguration:(NSString *)configuration
    storeOptions:(NSDictionary *)storeOptions
    error:(NSError **)error;
*/
/*
When a document is saved, Core Data calls the NSPersistentDocument method writeToURL:ofType:forSaveOperation:originalContentsURL:error:. You can override this method to add metadata to the new store before it is saved. (Recall that setting the metadata for a store does not change the information on disk until the store is saved.) */
/*- (BOOL)writeToURL:(NSURL *)absoluteURL
    ofType:(NSString *)typeName
    forSaveOperation:(NSSaveOperationType)saveOperation
    originalContentsURL:(NSURL *)absoluteOriginalContentsURL
    error:(NSError **)error;
*/
@end
