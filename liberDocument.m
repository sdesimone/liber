//
//  MyDocument.m
//  liberdoc
//
//  Created by sergio on 1/2/10.
//  Copyright Sergio De Simone 2010 . All rights reserved.
//

#import "liberManagedObject.h"
#import "liberPrintFormController.h"
#import "liberPrintPanelController.h"

#import "liberDocument.h"

@implementation LiberDocument

/**********************************************************
 ******************
 ****************** INITIALIZATION AND COCOA INTEGRATION
 ******************
 **********************************************************/

- (id)init 
{
    self = [super init];
    if (self != nil) {
        _currentLiberID = [NSNumber numberWithInt:0];
		_setUpPrintInfoDefaults = false;
    }
    return self;
}

- (void)dealloc
{
	[_currentLiberID release];
	[super dealloc];
}

- (NSString *)windowNibName 
{
    return @"liberDocument";
}

/**********************************************************
 ******************
 ****************** ACTIONS
 ******************
 **********************************************************/

- (IBAction)addNewLiber:(id)sender
{
	[_arrayController add:sender];
	[self performSelector: @selector(delayedScroll)
             withObject: nil
             afterDelay: 0.1];
}

/**********************************************************
 ******************
 ****************** HELPER METHODS
 ******************
 **********************************************************/

-(NSFont*)currentFont
{
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
	return [fontManager selectedFont];
}

-(void)delayedScroll
{
	[_tableView scrollRowToVisible:[_tableView numberOfRows]-1];
	[_drawerWindow makeFirstResponder:_firstTextField];
}

- (NSNumber*)maxLiberID
{
	static NSManagedObjectContext* moc = nil;
    if (moc != nil) {
		moc = [[NSManagedObjectContext alloc] init];
    }
	[moc setPersistentStoreCoordinator:[[self managedObjectContext] persistentStoreCoordinator]];
	
	NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"libro" inManagedObjectContext:moc];
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	NSArray* allImages = [moc executeFetchRequest:request error:nil];
	NSNumber* lastImageID = [NSNumber numberWithInt:0];
	if (allImages && [allImages count] > 0) {
		lastImageID = [[allImages objectAtIndex:0] valueForKey:@"id"];
	}
	return lastImageID;
}

/**********************************************************
 ******************
 ****************** PRINTING SUPPORT
 ******************
 **********************************************************/

- (NSPrintInfo*)printInfo {
    NSPrintInfo *pInfo = [super printInfo];
    if (!_setUpPrintInfoDefaults) {
			_setUpPrintInfoDefaults = YES;
			[pInfo setHorizontalPagination:NSFitPagination];
			[pInfo setHorizontallyCentered:NO];
			[pInfo setVerticallyCentered:NO];
			[pInfo setLeftMargin:36.0];
			[pInfo setRightMargin:36.0];
			[pInfo setTopMargin:36.0];
			[pInfo setBottomMargin:36.0];
    }
    return pInfo;
}
 
- (void)updatePrintView
{
	NSPrintInfo* pInfo = [self printInfo];
	[_liberPrintController prepareContentForPage:pInfo asList:[_liberPrintPanel linearPrintLayout]];
	[_printView reloadData];
	NSRange r = {0,[_printView numberOfRows]};
	if (r.length == 0)
		return;
	[_printView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:r]];
}

//-- following method is deprecated.
//-- printDocumentWithSettings:showPrintPanel:delegate:...
//-- should be used instead.
- (void)printShowingPrintPanel:(BOOL)showPanels
{
	NSPrintInfo* pInfo = [self printInfo];
	[self updatePrintView];
	NSPrintOperation *pop = [NSPrintOperation
						printOperationWithView:_printView
						printInfo:pInfo];
	[pop setShowsPrintPanel:showPanels];
	[pop setShowsProgressPanel:YES];
	if (showPanels) {
		NSPrintPanel* ppanel = [pop printPanel];
		[ppanel addAccessoryController:_liberPrintPanel];
	}

	//-- Run operation, which shows the Print panel if showPanels was YES
	[self runModalPrintOperation:pop
					delegate:nil
				didRunSelector:NULL
				 contextInfo:NULL];
}

/**********************************************************
 ******************
 ****************** METADATA MANAGEMENT
 ******************
 **********************************************************/
 
- (BOOL)setMetadataForStoreAtURL:(NSURL *)url
{
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    NSPersistentStore *pStore = [psc persistentStoreForURL:url];
    if (pStore != nil) {
        NSMutableDictionary *metadata = [[[psc metadataForPersistentStore:pStore] mutableCopy] autorelease];
        if (metadata == nil) {
            metadata = [NSMutableDictionary dictionary];
        }
				//-- custom logics to update metadata
//				[metadata setObject:[self currentLiberID] forKey:@"NextUnusedLiberID"];
        [psc setMetadata:metadata forPersistentStore:pStore];
        return YES;
    }
    return NO;
}

- (BOOL)getMetadataForStoreAtURL:(NSURL *)url
{
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    NSPersistentStore *pStore = [psc persistentStoreForURL:url];
    if (pStore != nil) {
        NSMutableDictionary *metadata = [[[psc metadataForPersistentStore:pStore] mutableCopy] autorelease];
        if (metadata == nil) {
//-- set default value for metadata
//            [self setCurrentLiberID:[self maxLiberID]];;
        } else {
//-- read stored value for metadata
//            [self setCurrentLiberID:[metadata objectForKey:@"NextUnusedLiberID"]];
				}
        return YES;
    }
    return NO;
}

/**********************************************************
 ******************
 ****************** OPEN/SAVE OVERRIDES
 ******************
 **********************************************************/

//-- update metadata on open/create
- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL*)url
    ofType:(NSString*)fileType
    modelConfiguration:(NSString*)configuration
    storeOptions:(NSDictionary*)storeOptions
    error:(NSError**)error
{
	NSMutableDictionary *options = nil;
	if (storeOptions != nil)
		options = [storeOptions mutableCopy];
	else
		options = [[NSMutableDictionary alloc] init];
	
	NSPersistentStoreCoordinator* psc = [[self managedObjectContext] persistentStoreCoordinator];
	NSDictionary* sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil URL:url error:error];
	if (sourceMetadata == nil)
			NSLog(@"No metadata found.");
	
	BOOL pscCompatibile = [[psc managedObjectModel]
							isConfiguration:nil
							compatibleWithStoreMetadata:sourceMetadata];

	if (!pscCompatibile) {
		NSLog(@"Will migrate.");

		NSFileManager* fileManager = [NSFileManager defaultManager];			
		NSString* dst = @"~/Library/Application Support/liber/";
		dst = [dst stringByExpandingTildeInPath];
		if ([fileManager fileExistsAtPath:dst] == NO)
			[fileManager createDirectoryAtPath:dst attributes:nil];
		dst = [dst stringByAppendingPathComponent:@"backups/"];
		if ([fileManager fileExistsAtPath:dst] == NO)
			[fileManager createDirectoryAtPath:dst attributes:nil];
		NSDate* bckDate = [[NSDate alloc] init];
		NSString* bckStr = [bckDate descriptionWithCalendarFormat:@"%y%m%d-%H%M%S" timeZone:nil locale:nil];
		[bckDate release];
		dst = [dst stringByAppendingPathComponent:[bckStr stringByAppendingFormat:@"-%@.%@", [[url path] lastPathComponent], @"zip"]];

		NSTask* bckTask = [[NSTask alloc] init];
		[bckTask setLaunchPath:@"/usr/bin/ditto"];
		[bckTask setArguments:
			[NSArray arrayWithObjects:@"-c", @"-k", @"--rsrc", [url path], dst, nil]];		
		[bckTask launch];
		[bckTask waitUntilExit];
		if ([bckTask terminationStatus] != 0)
			NSLog(@"Sorry, didn't work.");
		[bckTask release];
		
		[options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	} else {
		NSLog(@"Migration not necessary.");
	}

	BOOL ok = [super configurePersistentStoreCoordinatorForURL:url ofType:fileType modelConfiguration:configuration storeOptions:options error:error];
	[options release], options = nil;
	return ok;
}

//-- update metadata on save
- (BOOL)writeToURL:(NSURL *)absoluteURL
    ofType:(NSString *)typeName
    forSaveOperation:(NSSaveOperationType)saveOperation
    originalContentsURL:(NSURL *)absoluteOriginalContentsURL
    error:(NSError **)error
{

//    if ([self fileURL] != nil) {
//        [self setMetadataForStoreAtURL:[self fileURL]];
//    }

    BOOL b = [super writeToURL:absoluteURL
                      ofType:typeName
            forSaveOperation:saveOperation
         originalContentsURL:absoluteOriginalContentsURL
                       error:error];

	if (error) {
		NSEnumerator* enumerator = [[*error userInfo] keyEnumerator];
		id e = nil;
			while ((e = [enumerator nextObject])) {
			NSLog(@"error: (%d/%@) %@\n", [*error code], [*error domain], [[*error userInfo] valueForKey:e]);
		}
	}
	return b;
}

@end
