//
//  BDMapData.m
//  iJobs
//
//  Created by zc on 14-7-9.
//  Copyright (c) 2014年 zc. All rights reserved.
//

#import "BDMapData.h"
#import "BDPolygonEntity.h"
#import "BDPolygonGeometryEntity.h"
#import "BDPolygonPropertiesEntity.h"


#define COUNTRY_TOP  53.57
#define COUNTRY_LEFT 73.52
#define COUNTRY_RIGHT 135.1
#define COUNTRY_BOTTOM 18.14
@interface BDMapData()
{
    NSMutableArray *provinceArray;
    NSMutableDictionary *cityDict;
}

@end
@implementation BDMapData
static BDMapData* instance = nil;

@synthesize countryTopLatitude;
@synthesize countryBottomLatitude;
@synthesize countryLeftLongitude;
@synthesize countryRightLongitude;

@synthesize provinceLeftLongitude;
@synthesize provinceRightLongitude;
@synthesize provinceTopLatitude;
@synthesize provinceBottomLatitude;

+(BDMapData*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        countryTopLatitude = COUNTRY_TOP;
        countryLeftLongitude = COUNTRY_LEFT;
        countryRightLongitude = COUNTRY_RIGHT;
        countryBottomLatitude = COUNTRY_BOTTOM;
        provinceArray = [[NSMutableArray alloc]init];
        cityDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

//异步加载地图数据
-(void)readProvinceData
{
    __weak typeof (self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"province" withExtension:@"json"];
        NSString *provinceJson = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSError *error = nil;
        id data =   [NSJSONSerialization JSONObjectWithData:[provinceJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        for (NSDictionary *dict in data)
        {
            BDPolygonEntity *provinceEntity = [[BDPolygonEntity alloc]init];
            [provinceEntity loadFromDictionary:dict];
            [provinceArray addObject:provinceEntity];
            [wself readCityDataByProvinceId:provinceEntity.polygonId andProinceName:provinceEntity.propertiesEntity.name];
        }
    });
}

-(void)readCityDataByProvinceId:(NSString*)provinceId andProinceName:(NSString*)provinceName;
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:provinceId withExtension:@"json"];
    NSString *cityJson = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSError *error = nil;
    id data =   [NSJSONSerialization JSONObjectWithData:[cityJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in data)
    {
        BDPolygonEntity *cityEntity = [[BDPolygonEntity alloc]init];
        [cityEntity loadFromDictionary:dict];
        [cityArray addObject:cityEntity];
    }
    cityDict[provinceName] = cityArray;
}

-(NSMutableArray*)getProvinceData
{
  //  return [provinceArray mutableCopy];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (BDPolygonEntity *provinceEntity in provinceArray)
    {
        [array addObject:[provinceEntity copy]];
    }
    return array;
}

-(NSMutableDictionary*)getCityData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *allkeys = [cityDict allKeys];
    for (NSString *key in allkeys)
    {
        NSMutableArray *cityArray = cityDict[key];
        NSMutableArray *newCityArray = [cityArray mutableCopy];
        dict[key] = newCityArray;
        
    }
    return dict;
}
@end