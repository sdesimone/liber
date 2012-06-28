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

- (IBAction)addNewLiber:(id)sender
{
	[_arrayController add:sender];
	[self performSelector: @selector(delayedScroll)
             withObject: nil
             afterDelay: 0.1];
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
/*
- (NSNumber *)currentLiberID
{
	return _currentLiberID;
}

- (NSNumber *)newCurrentLiberID
{
	[self setCurrentLiberID:[NSNumber numberWithInt:[_currentLiberID intValue] + 1]];
	return _currentLiberID;
}

- (void)setCurrentLiberID:(NSNumber *)curLibID
{
    if (curLibID != _currentLiberID) {
        [_currentLiberID release];
        _currentLiberID = [curLibID retain];
    }
}

- (BOOL)setMetadataForStoreAtURL:(NSURL *)url
{
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    NSPersistentStore *pStore = [psc persistentStoreForURL:url];
    if (pStore != nil) {
        NSMutableDictionary *metadata = [[[psc metadataForPersistentStore:pStore] mutableCopy] autorelease];
        if (metadata == nil) {
            metadata = [NSMutableDictionary dictionary];
        }
				//-- custom logics
				[metadata setObject:[self currentLiberID] forKey:@"NextUnusedLiberID"];
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
            [self setCurrentLiberID:[self maxLiberID]];;
        } else {
            [self setCurrentLiberID:[metadata objectForKey:@"NextUnusedLiberID"]];
				}
        return YES;
    }
    return NO;
}

//-- update metadata on open/create
- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url
    ofType:(NSString *)fileType
    modelConfiguration:(NSString *)configuration
    storeOptions:(NSDictionary *)storeOptions
    error:(NSError **)error
{
    BOOL ok = [super configurePersistentStoreCoordinatorForURL:url
                ofType:fileType modelConfiguration:configuration
                storeOptions:storeOptions error:error];

    if (ok) {
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext]
                persistentStoreCoordinator];
        NSPersistentStore *pStore = [psc persistentStoreForURL:url];
        id existingMetadata = [[psc metadataForPersistentStore:pStore]
                objectForKey:(NSString *)kMDItemKeywords];
        if (existingMetadata == nil) {
            ok = [self setMetadataForStoreAtURL:url];
        }
    }
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
			NSLog(@"error: %@\n", [[*error userInfo] valueForKey:e]);
		}
	}
	return b;
}
*/
@end
