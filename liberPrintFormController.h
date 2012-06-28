//
//  liberPrintFormController.h
//  liberdoc
//
//  Created by sergio on 1/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LiberPrintFormController : NSViewController {
	IBOutlet NSView* _listView;
	IBOutlet NSArrayController* _arrayController;
	LiberManagedObject* _managedObject;
	NSMutableArray* _printDataSource;
}

- (BOOL)prepareContentForPage:(NSPrintInfo*)pInfo asList:(BOOL)listFlag;
- (void)setMob:(LiberManagedObject*)mob;
- (LiberManagedObject*)mob;

@end
