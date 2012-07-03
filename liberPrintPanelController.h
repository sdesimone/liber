//
//  liberPrintPanelController.h
//  liberdoc
//
//  Created by Sergio De Simone on 2/9/10.
//

#import <Cocoa/Cocoa.h>

@class LiberDocument;

@interface LiberPrintPanelController : NSViewController <NSPrintPanelAccessorizing>
{
	IBOutlet LiberDocument* _document;
	BOOL _linearPrintLayout;
}

- (IBAction)changePrintLayout:(id)sender;

- (BOOL) linearPrintLayout;
- (void) setLinearPrintLayout: (BOOL)linear;

@end
