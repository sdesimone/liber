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

- (NSString *)author;
- (void)setAuthor:(NSString *)value;

- (NSString *)keys;
- (void)setKeys:(NSString *)value;

- (NSString *)summary;
- (void)setSummary:(NSString *)value;

- (NSNumber *)id;
- (void)setId:(NSNumber *)value;

- (NSString *)notes;
- (void)setNotes:(NSString *)value;

- (NSString *)title;
- (void)setTitle:(NSString *)value;

- (NSString *)date;
- (void)setDate:(NSString *)value;

- (NSString *)publisher;
- (void)setPublisher:(NSString *)value;

- (NSString *)printRepresentation;

- (id)dictionary;

@end
