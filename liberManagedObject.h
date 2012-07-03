//
//  LiberManagedObject.h
//  liberdoc
//
//  Created by Sergio De Simone on 1/5/10.
//  Copyright 2010 Sergio De Simone. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LiberManagedObject :  NSManagedObject  
{
}

- (void) awakeFromInsert;

@property (nonatomic, retain) NSString* author;
@property (nonatomic, retain) NSString* keys;
@property (nonatomic, retain) NSString* summary;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSString* publisher;
@property (nonatomic, retain) NSNumber* id;
@property (nonatomic, retain) NSString* notes;

/*- (NSString *)author;
- (void)setAuthor:(NSString *)value;

- (NSString *)keys;
- (void)setKeys:(NSString *)value;

- (NSString *)summary;
- (void)setSummary:(NSString *)value;

- (NSNumber *)id;
- (void)setId:(NSNumber *)value;

- (NSData*)notes;
- (void)setNotes:(NSData*)value;
//- (void)setNotes:(NSString*)value;

//- (NSData*)notesFromString;
//- (void)setNotes:(NSString *)value;

- (NSString *)title;
- (void)setTitle:(NSString *)value;

- (NSString *)date;
- (void)setDate:(NSString *)value;

- (NSString *)publisher;
- (void)setPublisher:(NSString *)value;
*/

- (NSString *)printRepresentation;

- (id)dictionary;

@end
