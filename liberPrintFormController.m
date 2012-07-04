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
	NSSize optSize = [pInfo paperSize];
//	float c = [[[pInfo dictionary] objectForKey:NSPrintBottomMargin] floatValue] +
		[[[pInfo dictionary] objectForKey:NSPrintTopMargin] floatValue];
//	optSize.height = optSize.height - c;
	float scale = [[[pInfo dictionary] objectForKey:NSPrintScalingFactor] floatValue];
    optSize.height /= scale;
	if (optSize.height > [formView frame].size.height)
		optSize.height = optSize.height/floor(optSize.height/[formView frame].size.height)-1;
	else
		optSize.height = [formView frame].size.height-1;
	[formView setFrameSize:optSize];
	for (LiberManagedObject* mob in [_arrayController selectedObjects]) {
		[self setMob:mob];
		NSImage *image = [[NSImage alloc] init];
		NSData *data = [formView dataWithPDFInsideRect:[formView frame]];
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

- (CGFloat)tableView:(NSTableView*)tableView heightOfRow:(NSInteger)row
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
