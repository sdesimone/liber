//
//  liberPrintFormController.m
//  liberdoc
//
//  Created by sergio on 1/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "liberManagedObject.h"
#import "liberPrintFormController.h"

@implementation LiberPrintFormController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:@"liberPrintForm" bundle:nil]) {
		_printDataSource = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_printDataSource release];
	[super dealloc];
}

- (BOOL)prepareContentForPage:(NSPrintInfo*)pInfo asList:(BOOL)listFlag
{
	[_printDataSource removeAllObjects];
	NSView* formView = (listFlag)?_listView:[self view];
	NSRect optimumFrame = {[formView bounds].origin,
							{[pInfo paperSize].width,
							[pInfo paperSize].height / floor([pInfo paperSize].height/[formView bounds].size.height)}};
	[formView setFrame:optimumFrame];
	for (LiberManagedObject* mob in [_arrayController selectedObjects]) {
		[self setMob:mob];
		NSImage *image = [[NSImage alloc] init];
		NSData *data = [formView dataWithPDFInsideRect:[formView bounds]];
		[image addRepresentation:[NSPDFImageRep imageRepWithData:data]];
		[_printDataSource addObject:image];
		[image release];
	}
	return true;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
//	if ([[_arrayController selectedObjects] count] > 0)
		return [[_arrayController selectedObjects] count];
//	else
//		return [[_arrayController arrangedObjects] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [_printDataSource objectAtIndex:row];
}

- (float)tableView:(NSTableView*)tableView heightOfRow:(int)row
{
	return [[_printDataSource objectAtIndex:row] size].height;
}

- (LiberManagedObject*)mob
{
	return _managedObject;
}

- (void)setMob:(LiberManagedObject*)mob
{
	if (_managedObject != mob) {
			[self willChangeValueForKey:@"mob"];
			[_managedObject release];
			_managedObject = [mob retain];
      [self didChangeValueForKey:@"mob"];
	}
}

@end
