//
//  LibroMigratorPolicy.m
//  liberdoc
//
//  Created by sergio on 4/29/10.
//

#import "libroMigrationPolicy.h"

@implementation LibroMigrationPolicy

-(BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject*)mobj entityMapping:(NSEntityMapping*)mapping manager:(NSMigrationManager*)manager error:(NSError**)error
{
	float sourceVersion = [[[mapping userInfo] valueForKey:@"sourceVersion"] floatValue];
//	if (sourceVersion == 1.1) {
		NSString* notes = [mobj valueForKey:@"notes"];
		NSData* notesAsData = [[NSData alloc] initWithData:[notes dataUsingEncoding:NSUnicodeStringEncoding]];
		NSArray *attributeMappings = [mapping attributeMappings];
		for (int count = 0; count < [attributeMappings count]; count++) {
			NSPropertyMapping* currentMapping = [attributeMappings objectAtIndex:count];
			if( [[currentMapping name] isEqualToString:@"notes"] )
				[currentMapping setValueExpression:[NSExpression expressionForConstantValue:notesAsData]];
		}
//	}
	return [super createDestinationInstancesForSourceInstance:mobj entityMapping:mapping manager:manager error:error];
}

@end
