//
//  NSObject+Helper.m
//
//  Created by Carl Shen on 12-8-16.
//  Copyright 2012 ailk. All rights reserved.
//

#import "NSObject+Helper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSObject(common)


//UIColor 转UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
// 去掉uitableview多余分割线
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (NSMutableString *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters{
    
    NSMutableString *urlString =[NSMutableString string];   //The URL starts with the base string[urlString appendString:baseString];
    
    [urlString appendString:baseString];
    
    NSString *escapedString;
    
    NSInteger keyIndex = 0;
    
    for (id key in parameters) {
        
        //First Parameter needs to be prefixed with a ? and any other parameter needs to be prefixed with an &
        if(keyIndex ==0) {
            escapedString =(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[parameters valueForKey:key], NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
            
            [urlString appendFormat:@"?%@=%@",key,escapedString];
            [escapedString release];
            
        }else{
            escapedString =(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[parameters valueForKey:key], NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
            
            [urlString appendFormat:@"&%@=%@",key,escapedString];
            [escapedString release];
        }
        keyIndex++;
    }
    return urlString;
}


//获取以前的日期(N天前)
+(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)day
{
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    [calender release];
    return mDate;
}

//获取以前的日期(N月前)
+(NSDate*)getPriousDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    [calender release];
    return mDate;
}

//根据指定格式获取日期字符串
+(NSString*)getDateTitleWithFormat:(NSDate* )ddatadate withFormat:(NSString*) strformatter
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:strformatter];
    NSString* strDateTitle = [dateFormatter stringFromDate:ddatadate];
    [dateFormatter release];
    return strDateTitle;
}

//获取当前时间
+(NSString*)currentTime
{
    NSString* strCurrentTime = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"];
    return strCurrentTime;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+(NSString*)CreateDocumentsfileManager:(NSString*)fileName
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [APPDocumentsDirectory stringByAppendingPathComponent:fileName];
    // 创建目录
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:testDirectory])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    return testDirectory;
}

+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue =NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    if (0x278b <= hs
                         && hs <= 0x2792) {
                        returnValue =NO;
                    }
                    else
                    {
                        returnValue =YES;
                    }
                    
                }
                else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}

// 计算转换后字符的个数

+(NSUInteger)lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}

//根据时间字段对数组进行排序
+ (NSArray*)sortDictionayrForDate:(NSArray*)Source dateKey:(NSString*)dateKey
{
    NSArray *sortedArray = [Source sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* strdate1 = [obj1 objectForKeySafe:dateKey];
        NSString* strdate2 = [obj2 objectForKeySafe:dateKey];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        
        [dateFormat setDateFormat:@"YYYY-MM-DD"];//设定时间格式,这里可以设置成自己需要的格式
        
        NSDate *date1 =[dateFormat dateFromString:strdate1];
        NSDate *date2 =[dateFormat dateFromString:strdate2];
        
        NSComparisonResult result = [date1 compare:date2];
        
        switch(result)
        {
            case NSOrderedAscending:
                return NSOrderedDescending;
            case NSOrderedDescending:
                return NSOrderedAscending;
            case NSOrderedSame:
                return NSOrderedSame;
            default:
                return NSOrderedSame;
        } // 时间从近到远（远近相对当前时间而言）
        
    }];
    DLog(@"wxy sortedArray = %@",sortedArray);
    return sortedArray;
}
+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
//// 正常号转银行卡号 － 增加4位间的空格
//+(NSString *)normalNumToBankNum
//{
//    NSString *tmpStr = [self bankNumToNormalNum];
//    
//    int size = (tmpStr.length / 4);
//    
//    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
//    for (int n = 0;n < size; n++)
//    {
//        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
//    }
//    
//    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
//    
//    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
//    
//    return tmpStr;
//}
//
//// 银行卡号转正常号 － 去除4位间的空格
//+(NSString *)bankNumToNormalNum
//{
//    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//}
/*
//转千分位
-(NSString*) toThousand:(NSString*) strnormal
{
	NSMutableString* strThousand = [NSMutableString stringWithString:strnormal];
	
	NSRange range = [strThousand rangeOfString:@"."];
	
	int iLen;
	if(range.length == 0){
		iLen = [strThousand length];
	}else{
		iLen = range.location;
	}
	int iWhole = iLen / 3;
	int iRemainder = iLen % 3;
	int iPos;
	
	for(int iIndex=iWhole; iIndex>0; iIndex--){
		iPos = iRemainder + (iIndex-1)*3;
		if(iPos != 0){
			if(iPos != 1 || (iPos == 1 && ![[strThousand substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"])){
				[strThousand insertString:@"," atIndex:iPos];
			}
		}
	}
	return strThousand;
}

-(int)getRandNumber:(int)imaxnumber
{
	return arc4random()%imaxnumber;
}

//在指定array中寻找指定的字符串
-(int)findString:(NSArray*) arrStr forStr:(NSString*) strFindStr
{
	int iNumber = [arrStr count];
	int iIndex;
	
	for(iIndex=0; iIndex<iNumber; iIndex++){
		if([[arrStr objectAtIndex:iIndex] isEqualToString:strFindStr]){//如果找到了指定字符串
			return iIndex;
		}
	}
	
	return -1;
}


//根据十六进制颜色值解析成RGB值
-(NSArray*) HexString2RGB:(NSString*)hexstring 
{	
	NSString* cString = [[hexstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters 	
	if ([cString length] < 6) 		
		return 0; 		
	
	// strip 0X if it appears 	
	if([cString hasPrefix:@"0X"]) 		
		cString = [cString substringFromIndex:2]; 	
	if([cString hasPrefix:@"#"]) 		
		cString = [cString substringFromIndex:1]; 	
	if([cString length] != 6)
		return 0; 		
	
	// Separate into r, g, b substrings 	
	NSRange range; 	
	range.location = 0; 	
	
	range.length = 2; 	
	NSString* rString = [cString substringWithRange:range]; 	
	
	range.location = 2; 	
	NSString* gString = [cString substringWithRange:range]; 	
	
	range.location = 4; 	
	NSString* bString = [cString substringWithRange:range]; 	
	
	// Scan values 
	unsigned int r, g, b;	
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
 	[[NSScanner scannerWithString:gString] scanHexInt:&g]; 
	[[NSScanner scannerWithString:bString] scanHexInt:&b]; 	
	
	NSArray *rgb = [NSArray arrayWithObjects:
					[NSNumber numberWithInt:r],					
					[NSNumber numberWithInt:g],				
					[NSNumber numberWithInt:b],nil];	
	return rgb;
}

//根据16进制获取颜色
-(UIColor*)colorWithHexString:(NSString*) hexstring
{
	NSArray *rgb = [self HexString2RGB:hexstring];
	
	unsigned int r = [[rgb objectAtIndex:0] intValue];	
	unsigned int g = [[rgb objectAtIndex:1] intValue];	
	unsigned int b = [[rgb objectAtIndex:2] intValue];
	
	return [UIColor colorWithRed:((float) r / 255.0f) 						   
						   green:((float) g / 255.0f) 							
							blue:((float) b / 255.0f) 						   
						   alpha:1.0f];
}



//寻找最大值索引值
-(int)findMaxIndex:(NSMutableArray*) arorig
{
	if([arorig count] == 1){
		return 0;
	}
	
	int iIndex = 0;
	float fMax = [[arorig objectAtIndex:iIndex] doubleValue];
	
	//逐个进行比较
	for(int i=1; i<[arorig count]; i++){
		float fTmp = [[arorig objectAtIndex:i] doubleValue];
		if(fTmp > fMax){//发现一个更大的
			iIndex = i;
			fMax = fTmp;
		}
	}
	return iIndex;
}

//寻找最小值索引值
-(int)findMinIndex:(NSMutableArray*) arorig
{
	if([arorig count] == 1){
		return 0;
	}
	
	int iIndex = 0;
	float fMax = [[arorig objectAtIndex:iIndex] doubleValue];
	
	//逐个进行比较
	for(int i=1; i<[arorig count]; i++){
		float fTmp = [[arorig objectAtIndex:i] doubleValue];
		if(fTmp < fMax){//发现一个更小的
			iIndex = i;
			fMax = fTmp;
		}
	}
	return iIndex;
}

//从除了指定下标之外，寻找最大值索引值
-(int)findMaxIndex:(NSMutableArray*) arorig exceptOfIndex:(NSMutableArray*)arexceptindex
{
	if([arorig count] == 1){
		return 0;
	}
	bool bFind = false;
	int iFromIndex;
	int i;
	float fMax;
	int iIndex;
	
	//先找到第一个不在exceptindex中的下标
	for(int i=0; i<[arorig count]; i++){
		NSString* strTmp = [NSString stringWithFormat:@"%d", i];
		if([NSObject findString:arexceptindex forStr:strTmp] == -1){
			//找到了
			iFromIndex = i;
			bFind = true;
			break;
		}
	}
	
	if(!bFind){
		iFromIndex = 0;
		
	}
	
	fMax = [[arorig objectAtIndex:iFromIndex] doubleValue];
	iIndex = iFromIndex;
	
	//逐个进行比较
	for(i=iFromIndex; i<[arorig count]; i++){
		
		NSString* strIndex = [NSString stringWithFormat:@"%d", i];
		//先确保其不在已搜索范围
		if([NSObject findString:arexceptindex forStr:strIndex] != -1){
			continue;
		}
		
		float fTmp = [[arorig objectAtIndex:i] doubleValue];
		if(fTmp > fMax){//发现一个更大的
			iIndex = i;
			fMax = fTmp;
		}
	}
	return iIndex;
}

//从除了指定下标之外，寻找最小值索引值
-(int)findMinIndex:(NSMutableArray*) arorig exceptOfIndex:(NSMutableArray*)arexceptindex
{
	if([arorig count] == 1){
		return 0;
	}
	bool bFind = false;
	int iFromIndex;
	int i;
	float fMin;
	int iIndex;
	
	//先找到第一个不在exceptindex中的下标
	for(int i=0; i<[arorig count]; i++){
		NSString* strTmp = [NSString stringWithFormat:@"%d", i];
		if([NSObject findString:arexceptindex forStr:strTmp] == -1){
			//找到了
			iFromIndex = i;
			bFind = true;
			break;
		}
	}
	
	if(!bFind){
		iFromIndex = 0;
	}
	
	fMin = [[arorig objectAtIndex:iFromIndex] doubleValue];
	iIndex = iFromIndex;
	
	//逐个进行比较
	for(i=iFromIndex; i<[arorig count]; i++){
		
		NSString* strIndex = [NSString stringWithFormat:@"%d", i];
		//先确保其不在已搜索范围
		if([NSObject findString:arexceptindex forStr:strIndex] != -1){
			continue;
		}
		
		
		float fTmp = [[arorig objectAtIndex:i] doubleValue];
		if(fTmp < fMin){//发现一个更小的
			iIndex = i;
			fMin = fTmp;
		}
	}
	return iIndex;
}

//将数组排序
-(NSMutableArray*)sortArray:(NSMutableArray*) arorig withSortType:(int) isorttype
{
	NSMutableArray* arSort = [[NSMutableArray alloc] init];
	
	int iIndex;
	
	NSMutableArray* arTmpArray = [NSMutableArray arrayWithArray:arorig];
	if(isorttype == 0){//降序
		do{
			iIndex = [NSObject findMaxIndex:arTmpArray];//寻找最大的
			[arSort addObject:[arTmpArray objectAtIndex:iIndex]];
			[arTmpArray removeObjectAtIndex:iIndex];
		}while([arSort count] != [arorig count]);//排序完毕
		return arSort;
	}else if(isorttype == 1){//升序
		do{
			iIndex = [NSObject findMinIndex:arTmpArray];//寻找最小的
			[arSort addObject:[arTmpArray objectAtIndex:iIndex]];
			[arTmpArray removeObjectAtIndex:iIndex];
		}while([arSort count] != [arorig count]);//排序完毕	
		return arSort;
	}else{//未知方式,直接返回
		return arorig;
	}
}

//将数组下标排序
-(NSMutableArray*)sortArrayIndex:(NSMutableArray*) arorig withSortType:(int) isorttype
{
	NSMutableArray* arSortIndex = [[NSMutableArray alloc] init];
	
	int iIndex;
	
	NSMutableArray* arTmpArray = [NSMutableArray arrayWithArray:arorig];
	if(isorttype == 0){//降序
		do{
			iIndex = [NSObject findMaxIndex:arTmpArray exceptOfIndex:arSortIndex];//从除了指定下标之外，寻找最大的
			[arSortIndex addObject:[NSString stringWithFormat:@"%d", iIndex]];
		}while([arSortIndex count] != [arorig count]);//排序完毕
		return arSortIndex;
	}else if(isorttype == 1){//升序
		do{
			iIndex = [NSObject findMinIndex:arTmpArray exceptOfIndex:arSortIndex];//从除了指定下标之外，寻找最小的
			[arSortIndex addObject:[NSString stringWithFormat:@"%d", iIndex]];
		}while([arSortIndex count] != [arorig count]);//排序完毕
		return arSortIndex;
	}else{//未知方式,直接返回
		return nil;
	}
}

//将数组按某一列排序
-(NSMutableArray*)sortArraysByCol:(NSMutableArray*) arorig withColumnMember:(int)imember withColumnIndex:(int) isortcol withSortType:(int) isorttype
{
	int iGroup = [arorig count]/imember;
	int iGroupIndex;
	NSMutableArray* arSortArrays = [[[NSMutableArray alloc] init]autorelease];
	NSMutableArray* arSortColumnIndex;
	int i;
	int iRealRow;
	
	//先将排序单独组成一个数组
	NSMutableArray* arColumn = [[NSMutableArray alloc] init];
	for(iGroupIndex=0; iGroupIndex<iGroup; iGroupIndex++){
		NSMutableString* strTmp = [NSMutableString stringWithString:[arorig objectAtIndex:(imember*iGroupIndex+isortcol)]];
		for(int i=[strTmp length]-1; i>=0; i--){
			if([[strTmp substringWithRange:NSMakeRange(i, 1)] isEqualToString:@","]){//删除“千分位”
				[strTmp deleteCharactersInRange:NSMakeRange(i, 1)];
			}
		}
		[arColumn addObject:strTmp];
	}
	
	//下标排序
	arSortColumnIndex= [NSObject sortArrayIndex:arColumn withSortType:isorttype];
	[arColumn release];
	//将数组整体排序
	for(iGroupIndex=0; iGroupIndex<iGroup; iGroupIndex++){
		iRealRow = [[arSortColumnIndex objectAtIndex:iGroupIndex]intValue];
		for(i=0; i<imember; i++){
			[arSortArrays addObject:[arorig objectAtIndex:(iRealRow*imember+i)]];
		}
	}
    [arSortColumnIndex release];
	return arSortArrays;
}

//千分位格式化字符串
-(NSString*)formatThousand:(NSString*)strnormal
{
	if([strIfThousand isEqualToString:@"Y"]){
		return [NSObject toThousand:strnormal];
	}else{
		return strnormal;
	}
}

//根据刻度数重新计算整数值
-(float)calculateIntegerValue:(float)fvalue sectionnumber:(int)isectionnumber adjust:(int)iadjust
{
	NSString* strSectionValue = [NSString stringWithFormat:@"%d", (int)fvalue/isectionnumber];
	int i;
	if(fvalue < 1){//如果值小于1
		return fvalue * 1.2;
	}else if(fvalue < 10){//如果值1-9
		return (int)fvalue+1;
	}else{//如果值>10
		int iLength = [strSectionValue length];
		int iNewSectionValue = [strSectionValue intValue];
		for(i=0; i<iLength-1; i++){
			iNewSectionValue /= 10;
		}
		if(iNewSectionValue >= 0){
			if(iadjust > 0){
				iNewSectionValue += 1;
			}else{
				iNewSectionValue -= 1;
			}
		}else{
			iNewSectionValue -= 1;
		}
		for(i=0; i<iLength-1; i++){
			iNewSectionValue *= 10;
		}
		return iNewSectionValue*isectionnumber;
	}	
}

//组装请求参数-1
-(NSString*)assemblePara:(NSString*)strvisittype
{
	NSString* strPara = [NSString stringWithFormat:@"{visitType:'%@',mobileType:'%@',uid:'%@',fusioncharts:'fc'}",
						 strvisittype, strDeviceType, strUID];
	return strPara;
}

//组装请求参数-2
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',statDate:'%@',rptCode:'%@',uid:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strdatadate, strrptcode, strUID];
	return strPara;
}

//组装请求参数-3
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype channelcode:(NSString*)strchannelcode datadate:(NSString*)strdatadate
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',channelCode:'%@',statDate:'%@',rptCode:'%@',uid:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strchannelcode, strdatadate, strrptcode, strUID];
	return strPara;
}

//组装请求参数-4
-(NSString*)assemblePara:(NSString*)strvisittype username:(NSString*)strusername password:(NSString*)strpassword
{
	NSString* strPara = [NSString stringWithFormat:@"{visitType:'%@',mobileType:'%@',uid:'%@',username:'%@',password:'%@',fusioncharts:'fc'}",
						 strvisittype, strDeviceType, strUID, strusername, strpassword];
	return strPara;
}

//组装请求参数-5
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate kind:(NSString*)strkind
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',statDate:'%@',rptCode:'%@',uid:'%@', kind:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strdatadate, strrptcode, strUID, strkind];
	return strPara;
}

//组装请求参数-6
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate channelcode:(NSString*)strchannelcode
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',statDate:'%@',rptCode:'%@',uid:'%@',channelCode:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strdatadate, strrptcode, strUID, strchannelcode];
	return strPara;
}

//组装请求参数-7
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate mac:(NSString*)strmac
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',statDate:'%@',rptCode:'%@',uid:'%@',mac:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strdatadate, strrptcode, strUID, strmac];
	return strPara;
}

//组装请求参数-8
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate mac:(NSString*)strmac searchtype:(NSString*)strsearchtype
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',statDate:'%@',rptCode:'%@',uid:'%@',mac:'%@',searchtype:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strdatadate, strrptcode, strUID, strmac, strsearchtype];
	return strPara;
}

//组装请求参数-9
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype datadate:(NSString*)strdatadate mac:(NSString*)strmac controltype:(NSString*)strcontroltype
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',statDate:'%@',rptCode:'%@',uid:'%@',mac:'%@',controltype:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strdatadate, strrptcode, strUID, strmac, strcontroltype];
	return strPara;
}

//组装请求参数-10
-(NSString*)assemblePara:(NSString*) strrptcode visittype:(NSString*)strvisittype programname:(NSString*)strprogramname datadate:(NSString*)strdatadate
{
	NSString* strPara = [NSString stringWithFormat:@"{mobileType:'%@',staffId:'%@',visitType:'%@',programName:'%@',statDate:'%@',rptCode:'%@',uid:'%@',fusioncharts:'fc'}", 
						 strDeviceType, strStaffID, strvisittype, strprogramname, strdatadate, strrptcode, strUID];
	return strPara;
}

//生成Range
-(NSArray*)makeRange:(int)iminvalue maxvalue:(int)imaxvalue;
{
	return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", iminvalue], [NSString stringWithFormat:@"%d", imaxvalue], nil];
}

//应用是否已安装
-(bool)isAppInstalled:(NSString*)strappname
{
	NSString* strRealAppUrl = [NSString stringWithFormat:@"%@://", strappname];
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strRealAppUrl]];
}

//UIView生成UIImage
-(UIImage *)getImageFromView:(UIView *)view
{
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;  
}


- (void)displayDataError:(UIWebView*)webView
{
	NSMutableString *displayErrorHTML = [NSMutableString stringWithString:@"<html><head>"];
	[displayErrorHTML appendString:@"<title>Chart Error</title>"];
	[displayErrorHTML appendString:@"</head><body>"];
	[displayErrorHTML appendString:@"<p>Unable to plot chart.<br/>Error receiving data from Twitter.</p>"];
	[displayErrorHTML appendString:@"</body></html>"];
	
	[webView loadHTMLString:displayErrorHTML baseURL:nil];
}
-(void)createChartData:(UIWebView *)webView chartData:(NSString*)strchartdata fusiontype:(NSString *)fusiontypeswf chartwidth:(NSString *)chartwidth chartHeight:(NSString *)chartheight
{
    NSLog(@"this is  ----[wxy] ----- createChartData the chartdata is %@",strchartdata);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSMutableString * htmlcontentstring ;
    // Setup chart HTML.
    htmlcontentstring = [NSMutableString stringWithFormat:@"%@", @"<html><head>"];
    [htmlcontentstring appendString:@"<script type='text/javascript' src='FusionCharts.js'></script>"];
    [htmlcontentstring appendString:@"<script src=\"jquery.min.js\"></script>"];
    [htmlcontentstring appendString:@"<script type='text/javascript' src='test.js'></script>"];
    
    
    // [htmlcontentstring appendString:@"<SCRIPT LANGUAGE = 'JavaScript'><function test(cmd,param){window.alert(\"1111\");}></SCRIPT>"];
    
    [htmlcontentstring appendString:@"</head><body><div id='chart_container'>Chart will render here.</div>"];
    [htmlcontentstring appendString:@"<script type='text/javascript'>"];
    [htmlcontentstring appendFormat:@"var chart_object = new FusionCharts('%@', 'twitter_data_chart', '%@', '%@', '0', '1');",fusiontypeswf, chartwidth, chartheight];
    
    
    [htmlcontentstring appendFormat:@"chart_object.setJSONData(%@);", strchartdata];
    
    
    [htmlcontentstring appendString:@"chart_object.render('chart_container');"];
    
    [htmlcontentstring appendString:@"</script></body></html>"];
    
    // Draw the actual chart.
    [self plotChart:webView htmlContent:htmlcontentstring];
}
- (void)plotChart:(UIWebView *)webView htmlContent:(NSMutableString *)htmlcontentstring
{
    NSURL *baseURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]]];
	[webView loadHTMLString:htmlcontentstring baseURL:baseURL];
}

-(NSString *) parseFusionChartJSON:(NSString *)strResult parseTypestart:(NSString*) strparseTypeStart
{
    NSLog(@"[wxy]--->>> strResult = %@ ,strparseTypeStart = %@ ",strResult,strparseTypeStart);
    
    if (strResult == nil || strparseTypeStart == nil ) {
        NSLog(@"[wxy]--->>> in the parseFusionChartsJSON the strResult or strparseType is NIL");
        return nil;
    }
    
    NSRange rsrange;
    rsrange.length=0;
    rsrange.location=1;//index是在头文件中申请好的全局变量.int型 初始值为0
    NSRange xrange=[strResult rangeOfString:strparseTypeStart];
    int x=xrange.location;
    //NSRange yrange=[strResult rangeOfString:strparseTypeEnd options:1 range:rsrange];
    //int y=yrange.location;
    
    NSLog(@"[wxy]--->>> xrange = %@ ",[[NSString alloc]initWithFormat:@"%d",x]);
    
    NSString *result;
    result=[strResult substringFromIndex:x+[strparseTypeStart length]+3];
    result= [result substringToIndex:result.length-2];
    NSLog(@"strResult=%@",result);
    return result;
}
*/
@end
