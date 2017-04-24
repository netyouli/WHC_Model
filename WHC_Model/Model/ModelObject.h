//
//  Model.h
//  WHC_Model
//
//  Created by WHC on 16/11/1.
//  Copyright © 2016年 WHC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface Head :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * ResponseTime;
@property (nonatomic , copy) NSString              * ReceiveTime;
@property (nonatomic , copy) NSString              * ResultMsg;
@property (nonatomic , assign) NSInteger              ResultCode;
@property (nonatomic , copy) NSString              * RequestTime;
@property (nonatomic , copy) NSString              * SessionId;

@property (nonatomic , strong) NSNumber * testNum;

@end

@interface ChangeRule :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * RuleRestriction;
@property (nonatomic , copy) NSString              * RuleNote;
@property (nonatomic , copy) NSString              * RuleRemarks;
@property (nonatomic , copy) NSString              * RuleRemarks_En;
@property (nonatomic , copy) NSString              * RuleNote_En;

@end

@interface FeeInfoList :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * FeeType;
@property (nonatomic , assign) NSInteger              Fee;

@end

@interface EndorseRule :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * RuleRestriction;
@property (nonatomic , copy) NSString              * RuleNote;
@property (nonatomic , copy) NSString              * RuleRemarks;
@property (nonatomic , copy) NSString              * RuleRemarks_En;
@property (nonatomic , copy) NSString              * RuleNote_En;

@end

@interface RefundRule :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * RuleRestriction;
@property (nonatomic , copy) NSString              * RuleNote;
@property (nonatomic , copy) NSString              * RuleRemarks;
@property (nonatomic , copy) NSString              * RuleRemarks_En;
@property (nonatomic , copy) NSString              * RuleNote_En;

@end

@interface PolicyRuleList :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * TravelerCategory;
@property (nonatomic , assign) BOOL              CanUpgrade;
@property (nonatomic , assign) NSInteger              Index;
@property (nonatomic , strong) ChangeRule              * ChangeRule;
@property (nonatomic , copy) NSString              * RefundFeeFormulaID;
@property (nonatomic , copy) NSString              * IsPackageProduct;
@property (nonatomic , strong) NSArray<FeeInfoList *>              * FeeInfoList;
@property (nonatomic , strong) EndorseRule              * EndorseRule;
@property (nonatomic , strong) RefundRule              * RefundRule;
@property (nonatomic , copy) NSString              * TicketType;

@end

@interface PriceInfo_Child :NSObject<NSCoding, NSCopying>
@property (nonatomic , assign) NSInteger              Rate;
@property (nonatomic , assign) NSInteger              TravelerCategory;
@property (nonatomic , assign) NSInteger              FDPrice;
@property (nonatomic , assign) NSInteger              HZPrice;
@property (nonatomic , assign) NSInteger              PrintPrice;
@property (nonatomic , assign) NSInteger              Discount;
@property (nonatomic , assign) NSInteger              CostPrice;
@property (nonatomic , assign) NSInteger              Price;
@property (nonatomic , assign) NSInteger              Subsidy;
@property (nonatomic , assign) NSInteger              Commission;
@property (nonatomic , assign) NSInteger              SalePrice;

@end

@interface AirLineShowEntity :NSObject<NSCoding, NSCopying>
@property (nonatomic , assign) NSInteger              Price;
@property (nonatomic , copy) NSString              * SubClass;

@end

@interface PriceInfo_Adult :NSObject<NSCoding, NSCopying>
@property (nonatomic , assign) CGFloat              Rate;
@property (nonatomic , assign) NSInteger              TravelerCategory;
@property (nonatomic , assign) NSInteger              FDPrice;
@property (nonatomic , assign) NSInteger              HZPrice;
@property (nonatomic , assign) NSInteger              PrintPrice;
@property (nonatomic , assign) NSInteger              Discount;
@property (nonatomic , assign) NSInteger              CostPrice;
@property (nonatomic , assign) NSInteger              Price;
@property (nonatomic , assign) NSInteger              Subsidy;
@property (nonatomic , assign) NSInteger              Commission;
@property (nonatomic , assign) NSInteger              SalePrice;

@end

@interface CabinInfoList :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * BookingClass;
@property (nonatomic , assign) BOOL              ApplyChild;
@property (nonatomic , assign) BOOL              IsSupportChildPolicy;
@property (nonatomic , copy) NSString              * CabinClass;
@property (nonatomic , assign) NSInteger              ProductSource;
@property (nonatomic , copy) NSString              * ProductType;
@property (nonatomic , copy) NSString              * RealSubclass;
@property (nonatomic , copy) NSString              * PolicyCategory;
@property (nonatomic , assign) NSInteger              BillType;
@property (nonatomic , strong) NSArray<NSNumber *>              * PolicyRuleIndexList;
@property (nonatomic , assign) NSInteger              SeatCount;
@property (nonatomic , strong) PriceInfo_Child              * PriceInfo_Child;
@property (nonatomic , copy) NSString              * PriceInfo_Infant;
@property (nonatomic , copy) NSString              * TicketDeadline;
@property (nonatomic , copy) NSString              * PolicyID;
@property (nonatomic , copy) NSString              * ProductAttribute;
@property (nonatomic , copy) NSString              * PID;
@property (nonatomic , assign) BOOL              IsSupportBabyPolicy;
@property (nonatomic , strong) AirLineShowEntity              * AirLineShowEntity;
@property (nonatomic , copy) NSString              * ProductID;
@property (nonatomic , copy) NSString              * SaleType;
@property (nonatomic , strong) PriceInfo_Adult              * PriceInfo_Adult;

@end

@interface StandardPriceList :NSObject<NSCoding, NSCopying>
@property (nonatomic , assign) NSInteger              Price;
@property (nonatomic , copy) NSString              * CabinClass;

@end


@interface LowestPriceCabin :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * BookingClass;
@property (nonatomic , assign) BOOL              ApplyChild;
@property (nonatomic , assign) BOOL              IsSupportChildPolicy;
@property (nonatomic , copy) NSString              * CabinClass;
@property (nonatomic , assign) NSInteger              ProductSource;
@property (nonatomic , copy) NSString              * ProductType;
@property (nonatomic , copy) NSString              * RealSubclass;
@property (nonatomic , copy) NSString              * PolicyCategory;
@property (nonatomic , assign) NSInteger              BillType;
@property (nonatomic , strong) NSArray<NSNumber *>              * PolicyRuleIndexList;
@property (nonatomic , assign) NSInteger              SeatCount;
@property (nonatomic , strong) PriceInfo_Child              * PriceInfo_Child;
@property (nonatomic , copy) NSString              * PriceInfo_Infant;
@property (nonatomic , copy) NSString              * TicketDeadline;
@property (nonatomic , copy) NSString              * PolicyID;
@property (nonatomic , copy) NSString              * ProductAttribute;
@property (nonatomic , copy) NSString              * PID;
@property (nonatomic , assign) BOOL              IsSupportBabyPolicy;
@property (nonatomic , strong) AirLineShowEntity              * AirLineShowEntity;
@property (nonatomic , copy) NSString              * ProductID;
@property (nonatomic , copy) NSString              * SaleType;
@property (nonatomic , strong) PriceInfo_Adult              * PriceInfo_Adult;

@end

@interface PunctualityRateDetail :NSObject<NSCoding, NSCopying>
@property (nonatomic , assign) NSInteger              Cancel;
@property (nonatomic , assign) NSInteger              Delay60To90;
@property (nonatomic , assign) CGFloat              OnTime;
@property (nonatomic , assign) NSInteger              Delay30To60;
@property (nonatomic , assign) NSInteger              DelayOver90;

@end

@interface FlightInfoList :NSObject<NSCoding, NSCopying>
@property (nonatomic , copy) NSString              * DeptAirportCode;
@property (nonatomic , copy) NSString              * DeptDateTime;
@property (nonatomic , assign) BOOL              IsFlyMan;
@property (nonatomic , copy) NSString              * DeptAirportName;
@property (nonatomic , copy) NSString              * ArrvCityCode;
@property (nonatomic , assign) NSInteger              NextDays;
@property (nonatomic , copy) NSString              * ArrvAirportName;
@property (nonatomic , copy) NSString              * ArrvAirportCode;
@property (nonatomic , copy) NSString              * FlightStopList;
@property (nonatomic , assign) NSInteger              DataSource;
@property (nonatomic , copy) NSString              * MealType;
@property (nonatomic , assign) CGFloat              PunctualityRate;
@property (nonatomic , copy) NSString              * CraftType;
@property (nonatomic , copy) NSString              * DeptCityCode;
@property (nonatomic , copy) NSString              * SharedFlight;
@property (nonatomic , copy) NSString              * ArrvCityName;
@property (nonatomic , assign) NSInteger              BuildFee;
@property (nonatomic , copy) NSString              * ArrvDateTime;
@property (nonatomic , assign) NSInteger              FuelFee;
@property (nonatomic , assign) NSInteger              SegmentIndex;
@property (nonatomic , copy) NSString              * CarrierName;
@property (nonatomic , copy) NSString              * FlightNumber;
@property (nonatomic , copy) NSString              * ArrvTerminalID;
@property (nonatomic , copy) NSString              * CarrierCode;
@property (nonatomic , copy) NSString              * DeptTerminalID;
@property (nonatomic , strong) NSArray<CabinInfoList *>              * CabinInfoList;
@property (nonatomic , assign) BOOL              IsShareFlight;
@property (nonatomic , strong) NSArray<StandardPriceList *>              * StandardPriceList;
@property (nonatomic , strong) LowestPriceCabin              * LowestPriceCabin;
@property (nonatomic , copy) NSString              * DeptCityName;
@property (nonatomic , strong) PunctualityRateDetail              * PunctualityRateDetail;

@end

@interface FlightListGroupList :NSObject<NSCoding, NSCopying>
@property (nonatomic , strong) NSArray<FlightInfoList *>              * FlightInfoList;
@property (nonatomic , assign) NSInteger              OrigDestSeqID;

@end

@interface ResponseBody :NSObject<NSCoding, NSCopying>
@property (nonatomic , strong) NSArray<PolicyRuleList *>              * PolicyRuleList;
@property (nonatomic , strong) NSArray<FlightListGroupList *>              * FlightListGroupList;
@property (nonatomic , assign) BOOL              IsCompleted;

@end

@interface ModelObjectSuper : NSObject<NSCoding, NSCopying>
@property (nonatomic , strong) Head              * Head;
@end

@interface ModelObject :ModelObjectSuper<NSCoding, NSCopying>
@property (nonatomic , strong) ResponseBody              * ResponseBody;
@property (nonatomic , assign) char mm;
@end

