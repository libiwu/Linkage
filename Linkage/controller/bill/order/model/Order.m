//
//  Order.m
//  Linkage
//
//  Created by lihaijian on 16/3/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Order.h"
#import "Cargo.h"
#import "OrderModel.h"
#import "SOImage.h"

#define kOrderRemoveKeys @[@"cargos",@"userId",@"objStatus",@"soImages"]
@implementation Order

#pragma mark - MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

+ (NSValueTransformer *)cargosJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Cargo class]];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    NSDictionary *transDic = @{
                               @(0): @(OrderTypeExport),
                               @(1): @(OrderTypeImport),
                               @(2): @(OrderTypeMainland),
                               @(3): @(OrderTypeSelf)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic defaultValue:@(OrderTypeExport) reverseDefaultValue:@(0)];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    NSDictionary *transDic = @{
                               @(0): @(OrderStatusUnDo),
                               @(1): @(OrderStatusDoing),
                               @(2): @(OrderStatusDone)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic defaultValue:@(OrderStatusUnDo) reverseDefaultValue:@(0)];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([@[@"takeTime",@"deliverTime",@"cargosRentExpire",@"createTime",@"customsIn",@"cargoTakeTime"] containsObject:key]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id dateString, BOOL *success, NSError *__autoreleasing *error) {
            if ([dateString isKindOfClass:[NSDate class]]) {
                return dateString;
            }else{
                return [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
            }
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            long long dTime = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
            return @(dTime);
        }];
    }
    return nil;
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if (JSONDictionary[@"cargo_no"] != nil) {
        return [ImportOrder class];
    }
    if (JSONDictionary[@"ship_name"] != nil) {
        return [ExportOrder class];
    }
    if (JSONDictionary[@"is_customs_declare"] != nil) {
        return [SelfOrder class];
    }
    
    if ([JSONDictionary[@"type"] integerValue] == OrderTypeExport) {
        return [ExportOrder class];
    }else if ([JSONDictionary[@"type"] integerValue] == OrderTypeImport){
        return [ImportOrder class];
    }else if ([JSONDictionary[@"type"] integerValue] == OrderTypeSelf){
        return [SelfOrder class];
    }
    
    return self;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([OrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)cargosEntityAttributeTransformer
{
    return [MTLManagedObjectAdapter transformerForModelPropertiesOfClass:[CargoModel class]];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"cargos":[Cargo class],@"soImages":[SOImage class]};
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        self.createTime = [NSDate date];
    }
    return self;
}

@end

/**
 * 进口
 */
@implementation ImportOrder
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"orderId":@"order_id",
                             @"companyId":@"company_id",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"cargosRentExpire":@"cargos_rent_expire",
                             @"billNo":@"bill_no",
                             @"cargoNo":@"cargo_no",
                             @"cargoCompany":@"cargo_company",
                             @"customsBroker":@"customs_broker",
                             @"customsHouseContact":@"customs_contact",
                             @"isTransferPort":@"is_transfer_port",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([ImportOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end

/**
 * 出口
 */
@implementation ExportOrder
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"orderId":@"order_id",
                             @"companyId":@"company_id",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"port":@"port",
                             @"customsIn":@"customs_in",
                             @"shipCompany":@"ship_company",
                             @"shipName":@"ship_name",
                             @"shipScheduleNo":@"ship_schedule_no",
                             @"isBookCargo":@"is_book_cargo",
                             @"isTransferPort":@"is_transfer_port",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([ExportOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"so"]];
    return keys;
}

+ (NSValueTransformer *)soImagesEntityAttributeTransformer
{
    return [MTLManagedObjectAdapter transformerForModelPropertiesOfClass:[SOImageModel class]];
}

@end

@implementation SelfOrder
//自备柜
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"companyId":@"company_id",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"isCustomsDeclare":@"is_customs_declare",
                             @"customsIn":@"customs_in",
                             @"cargoTakeTime":@"cargo_take_time",
                             @"isTransferPort":@"is_transfer_port",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([SelfOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keys;
}

@end

@implementation DriverTask
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSString *)managedObjectEntityName
{
    return @"DriverTask";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


@implementation DriverTaskHistory
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSString *)managedObjectEntityName
{
    return @"DriverTaskHistory";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end
