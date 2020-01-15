//
//  liberDelegate.m
//  liberdoc
//
//  Created by Sergio De Simone on 2/15/10.
//  Copyright 2010 Freescapes Labs. All rights reserved.
//

#import "liberDelegate.h"

@implementation LiberDelegate

- (id)init
{
	return [super init];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
	[self setAutomaticallyChecksForUpdates:YES];
	[self setAutomaticallyDownloadsUpdates:YES];
	[self checkForUpdatesInBackground];
//	[self checkForUpdates:self];
}

- (void)updater:(SUUpdater *)updater didFindValidUpdate:(SUAppcastItem *)update
{
	NSLog(@"Found Update!!!!");
}

// Sent immediately before installing the specified update.
- (void)updater:(SUUpdater *)updater willInstallUpdate:(SUAppcastItem *)update
{
	NSLog(@"Trying to install!!!!");
}

- (void)updaterDidNotFindUpdate:(SUUpdater *)update
{
	NSLog(@"Did not find any update!!!!");
}

@end
