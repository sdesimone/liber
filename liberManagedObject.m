// 
//  LiberManagedObject.m
//  liberdoc
//
//  Created by Sergio De Simone on 1/5/10.
//  Copyright 2010 Sergio De Simone. All rights reserved.
//

#import "liberManagedObject.h"
#import "liberDocument.h"


@implementation LiberManagedObject 

- (NSNumber *)newLiberID
{
	long currentLiberID = 0;
	NSManagedObjectContext* moc = nil;
    if (moc == nil) {
		moc = [[NSManagedObjectContext alloc] init];
    }
	[moc setPersistentStoreCoordinator:[[self managedObjectContext] persistentStoreCoordinator]];
	
	//-- fetch persisted mocs to find latest id
	NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"libro" inManagedObjectContext:moc];
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	NSArray* allLibri = [moc executeFetchRequest:request error:nil];
	if (allLibri && [allLibri count] > 0) {
		currentLiberID = [[[allLibri objectAtIndex:0] valueForKey:@"id"] intValue];
	}
	[moc release];
	
	//-- iterate over insertedObjects to check for newer mocs that have greater id
	NSSet* insertedObject = [[self managedObjectContext] insertedObjects];
	NSEnumerator* enumerator = [insertedObject objectEnumerator];
	NSManagedObject* mob = nil;
	while ((mob = [enumerator nextObject])) {
		if (currentLiberID < [[mob valueForKey:@"id"] intValue]) {
			currentLiberID = [[mob valueForKey:@"id"] intValue];
		}
	}
	return [[NSNumber numberWithInt:++currentLiberID] retain];
}

-(void)awakeFromInsert
{
	[super awakeFromInsert];
	[self setValue:[self newLiberID] forKey:@"id"];
}

- (NSString *)author 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"author"];
    tmpValue = [self primitiveValueForKey:@"author"];
    [self didAccessValueForKey:@"author"];
    
    return tmpValue;
}

- (void)setAuthor:(NSString *)value 
{
    [self willChangeValueForKey:@"author"];
    [self setPrimitiveValue:value forKey:@"author"];
    [self didChangeValueForKey:@"author"];
}

- (NSString *)keys 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"keys"];
    tmpValue = [self primitiveValueForKey:@"keys"];
    [self didAccessValueForKey:@"keys"];
    
    return tmpValue;
}

- (void)setKeys:(NSString *)value 
{
    [self willChangeValueForKey:@"keys"];
    [self setPrimitiveValue:value forKey:@"keys"];
    [self didChangeValueForKey:@"keys"];
}

- (NSString *)summary 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"summary"];
    tmpValue = [self primitiveValueForKey:@"summary"];
    [self didAccessValueForKey:@"summary"];
    
    return tmpValue;
}

- (void)setSummary:(NSString *)value 
{
    [self willChangeValueForKey:@"summary"];
    [self setPrimitiveValue:value forKey:@"summary"];
    [self didChangeValueForKey:@"summary"];
}

- (NSNumber *)id 
{
    NSNumber * tmpValue;
    
    [self willAccessValueForKey:@"id"];
    tmpValue = [self primitiveValueForKey:@"id"];
    [self didAccessValueForKey:@"id"];
    
    return tmpValue;
}

- (void)setId:(NSNumber *)value 
{
    [self willChangeValueForKey:@"id"];
    [self setPrimitiveValue:value forKey:@"id"];
    [self didChangeValueForKey:@"id"];
}

- (NSString *)notes 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"notes"];
    tmpValue = [self primitiveValueForKey:@"notes"];
    [self didAccessValueForKey:@"notes"];
    
    return tmpValue;
}

- (void)setNotes:(NSString *)value 
{
    [self willChangeValueForKey:@"notes"];
    [self setPrimitiveValue:value forKey:@"notes"];
    [self didChangeValueForKey:@"notes"];
}

- (NSString *)title 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"title"];
    tmpValue = [self primitiveValueForKey:@"title"];
    [self didAccessValueForKey:@"title"];
    
    return tmpValue;
}

- (void)setTitle:(NSString *)value 
{
    [self willChangeValueForKey:@"title"];
    [self setPrimitiveValue:value forKey:@"title"];
    [self didChangeValueForKey:@"title"];
}

- (NSString *)date 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"date"];
    tmpValue = [self primitiveValueForKey:@"date"];
    [self didAccessValueForKey:@"date"];
    
    return tmpValue;
}

- (void)setDate:(NSString *)value 
{
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveValue:value forKey:@"date"];
    [self didChangeValueForKey:@"date"];
}

- (NSString *)publisher 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"publisher"];
    tmpValue = [self primitiveValueForKey:@"publisher"];
    [self didAccessValueForKey:@"publisher"];
    
    return tmpValue;
}

- (void)setPublisher:(NSString *)value 
{
    [self willChangeValueForKey:@"publisher"];
    [self setPrimitiveValue:value forKey:@"publisher"];
    [self didChangeValueForKey:@"publisher"];
}

- (NSString *)printRepresentation 
{
    NSString *tmpValue;
    tmpValue = [[[NSString alloc] initWithFormat:@"%@\n%@\n\n", [self author], [self title]] autorelease];
    return tmpValue;
}

- (id)dictionary
{
	return [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"author", @"title", nil]];
}

@end
