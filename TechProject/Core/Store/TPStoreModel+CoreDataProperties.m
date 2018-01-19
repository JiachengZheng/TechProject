//
//  TPStoreModel+CoreDataProperties.m
//  
//
//  Created by zhengjiacheng on 2018/1/17.
//
//

#import "TPStoreModel+CoreDataProperties.h"

@implementation TPStoreModel (CoreDataProperties)

+ (NSFetchRequest<TPStoreModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TPStoreModel"];
}

@dynamic key;
@dynamic date;
@dynamic value;

@end
