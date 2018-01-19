//
//  TPStoreModel+CoreDataProperties.h
//  
//
//  Created by zhengjiacheng on 2018/1/17.
//
//

#import "TPStoreModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TPStoreModel (CoreDataProperties)

+ (NSFetchRequest<TPStoreModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) NSData *value;

@end

NS_ASSUME_NONNULL_END
