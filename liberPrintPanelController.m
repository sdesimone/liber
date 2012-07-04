//
//  liberPrintPanelController.m
//  liberdoc
//
//  Created by Sergio De Simone on 2/9/10.
//  Copyright 2010 HP Spain. All rights reserved.
//

#import "liberDocument.h"
#import "liberPrintPanelController.h"

@implementation LiberPrintPanelController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
// ?? initiliazing super?!
	if (self)
		_linearPrintLayout = YES;
	return self;
}

- (void)dealloc
{
//	[_printView release];
	[super dealloc];
}
*/

- (IBAction)changePrintLayout:(id)sender {
    [self setLinearPrintLayout:[sender state] ? YES : NO];
}
/*
- (void)setRepresentedObject:(id)printInfo {
    [super setRepresentedObject:printInfo];
    [self setLinearPrintLayout:YES];
//    [self setPageNumbering:[[[NSUserDefaults standardUserDefaults] objectForKey:NumberPagesWhenPrinting] boolValue]];
}
*/

//- (void)setLinearPrintLayout:(BOOL)flag {
/*    NSPrintInfo *printInfo = [self representedObject];
    [[printInfo dictionary] setObject:[NSNumber numberWithBool:flag] forKey:NSPrintHeaderAndFooter];
*/
//		_linearPrintLayout = flag;
//}

- (BOOL)linearPrintLayout {
//    NSPrintInfo *printInfo = [self representedObject];
//    return [[[printInfo dictionary] objectForKey:NSPrintHeaderAndFooter] boolValue];
	return _linearPrintLayout;
}

- (void) setLinearPrintLayout: (BOOL)linear
{
    [self willChangeValueForKey:@"linearPrintLayout"];
	_linearPrintLayout = linear;
	[_document updatePrintView];
    [self didChangeValueForKey:@"linearPrintLayout"];
}

- (NSSet *)keyPathsForValuesAffectingPreview {
    return [NSSet setWithObject:@"linearPrintLayout"];
}

- (NSArray *)localizedSummaryItems {
    return [NSArray arrayWithObject:
	    [NSDictionary dictionaryWithObjectsAndKeys:
		NSLocalizedStringFromTable(@"Linear Print Layout", @"LiberPrintPanel", @"Print panel summary item title for whether header and footer (page number, date, document title) should be printed"), NSPrintPanelAccessorySummaryItemNameKey,
		[self linearPrintLayout] ? NSLocalizedStringFromTable(@"On", @"LiberPrintPanel", @"Print panel summary value when header and footer printing is on") : NSLocalizedStringFromTable(@"Off", @"LiberPrintPanel", @"Print panel summary value when header and footer printing is off"), NSPrintPanelAccessorySummaryItemDescriptionKey,
		nil]];
}

@end
