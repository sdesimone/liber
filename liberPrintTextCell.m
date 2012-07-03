//
//  liberPrintTextCell.m
//  liberdoc
//
//  Created by Sergio De Simone on 1/12/10.
//

#import "liberPrintTextCell.h"
#import "liberManagedObject.h"
#import "liberPrintFormController.h"

@implementation LiberPrintTextCell

- (void)dealloc 
{
	[super dealloc];
}

//-- delegate method -tableView:heightForRow: recalculates row height
//-- then notifies the table via -noteHeightOfRowsWithIndexesChanged (all rows)

/* -- recenter vertically
- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSSize contentSize = [self cellSize];
    cellFrame.origin.y += (cellFrame.size.height - contentSize.height) / 2.0;
    cellFrame.size.height = contentSize.height;
	
	NSAttributedString *drawString = [self attributedStringValue];
	
	NSRange range;
	NSDictionary *attributes = [drawString attributesAtIndex:0 effectiveRange:&range];
	
	float maxWidth = cellFrame.size.width;
	float stringWidth = [drawString size].width;
	
	if (maxWidth < stringWidth)
	{
		int i;
		
		for (i = 0;i <= [drawString length];i++)
		{
			if ([[drawString attributedSubstringFromRange:NSMakeRange(0,i)]size].width >= maxWidth)
			{	
				drawString = [[NSMutableAttributedString alloc] initWithString:[[[drawString attributedSubstringFromRange:NSMakeRange(0,i-3)]string]stringByAppendingString:@"..."]attributes:attributes];
				[drawString autorelease];
			}
		}
	}
	
	[drawString drawInRect:cellFrame];
}
*/

/*
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSDictionary* dict = [self objectValue];
	NSLog(@"MINCHIAAAAA BEFORE\n\n");
	NSEnumerator* enumerator = [dict keyEnumerator];
	id e = nil;
    while ((e = [enumerator nextObject])) {
		NSLog(@"RECORD: %@\n", [dict valueForKey:e]);
	}
	NSLog(@"MINCHIAAAAA\n\n");

	LiberPrintFormController* viewController = [[[LiberPrintFormController alloc] initWithDictionary:dict] retain];
	NSView* formView = [viewController view];
	
//	NSObjectController* oc = [viewController objectController];

//    NSSize contentSize = [self cellSize];
//    cellFrame.origin.y += (cellFrame.size.height - contentSize.height) / 2.0;
//    cellFrame.size.height = contentSize.height;
		
//		[formView lockFocus];
//		NSBitmapImageRep *bmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect:(NSRect){{0, 0}, [formView bounds].size}];
//		[formView unlockFocus];

		cellFrame.size = [formView bounds].size;
		[formView display];
		NSBitmapImageRep *bmap = [formView bitmapImageRepForCachingDisplayInRect:[formView bounds]];
		[formView cacheDisplayInRect:[formView bounds] toBitmapImageRep:bmap];
		NSGraphicsContext *bmpCtx = [NSGraphicsContext graphicsContextWithBitmapImageRep:bmap];
		NSImage *image = [[NSImage alloc] init];
		[image addRepresentation:bmap];
		[bmap release];

    [NSGraphicsContext saveGraphicsState];
		{
			[NSGraphicsContext setCurrentContext:bmpCtx];
			// This grabs a CoreImage context from the bitmap image rep
			[image drawAtPoint:cellFrame.origin fromRect:[formView bounds] operation:NSCompositeCopy fraction:1.0];
		}
    [NSGraphicsContext restoreGraphicsState];    

//		[controlView cacheDisplayInRect:cellFrame toBitmapImageRep:bmap];
//-[NSView displayRectIgnoringOpacity:inContext:]

//	[super drawInteriorWithFrame:cellFrame inView:controlView];
}
*/
/*
- (void)editWithFrame:(NSRect)rect inView:(NSView *)view
								editor:(NSText*)text delegate:(id)object
								event:(NSEvent *)event
{
	if (icon) {
		rect.origin.x += 16;
		rect.size.width -= 16;
	}
	[super editWithFrame:rect inView:view editor:text delegate:object
			event:event];

}

- (void)selectWithFrame:(NSRect)rect inView:(NSView *)view
					editor:(NSText*)text delegate:(id)object
					start:(NSInteger)start length:(NSInteger)length
{
	if (icon) {
		rect.origin.x += 16;
		rect.size.width -= 16;
	}
	[super selectWithFrame:rect inView:view editor:text delegate:object
		start:start length:length];
}
*/
@end
