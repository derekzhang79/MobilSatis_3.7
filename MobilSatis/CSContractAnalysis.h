//
//  CSContractAnalysis.h
//  MobilSatis
//
//  Created by Ata Cengiz on 9/3/12.
//
//

#import <Foundation/Foundation.h>
#import "CSContractAnalysisDiscount.h"

@interface CSContractAnalysis : NSObject
{
    NSString *kunnr;
    NSString *name;
    NSString *contractNo;
    NSString *requestNo;
    NSString *approveNo;
    NSString *version;
    NSString *analysisStartingDate;
    NSString *analysisEndingDate;
    NSString *contractStartingDate;
    NSString *contractEndingDate;
    NSString *analysisCriteria;
    
    NSString *lastYearSystemSale;
    NSString *estimatedAnalysisSale;
    NSString *estimatedYearSale;
    NSString *enterpriseCapitalN;
    NSString *enterpriseCapitalM;
    NSString *cashBasedContract;
    NSString *cashBasedProduct;
    NSString *projectContractN;
    NSString *projectContractM;
    NSString *discountFromInvoice;
    NSString *periodicDiscount;
    NSString *enterpriseCredit;
    NSString *commercialContract;
    NSString *totalContract;
    
    NSString *grossIncome;
    NSString *brutIncome;
    NSString *pointToPoint;
    NSString *transferedCost;
    NSString *grossProceeds;
    NSString *grossPercentageWithoutOTV;
    NSString *grossPercentageWithOTV;
    NSString *estimatedTargetLitre;
   }

@property (nonatomic, retain) NSString *kunnr;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *contractNo;
@property (nonatomic, retain) NSString *requestNo;
@property (nonatomic, retain) NSString *approveNo;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *analysisStartingDate;
@property (nonatomic, retain) NSString *analysisEndingDate;
@property (nonatomic, retain) NSString *contractStartingDate;
@property (nonatomic, retain) NSString *contractEndingDate;
@property (nonatomic, retain) NSString *analysisCriteria;

@property (nonatomic, retain) NSString *lastYearSystemSale;
@property (nonatomic, retain) NSString *estimatedAnalysisSale;
@property (nonatomic, retain) NSString *estimatedYearSale;
@property (nonatomic, retain) NSString *enterpriseCapitalN;
@property (nonatomic, retain) NSString *enterpriseCapitalM;
@property (nonatomic, retain) NSString *cashBasedContract;
@property (nonatomic, retain) NSString *cashBasedProduct;
@property (nonatomic, retain) NSString *projectContractN;
@property (nonatomic, retain) NSString *projectContractM;
@property (nonatomic, retain) NSString *discountFromInvoice;
@property (nonatomic, retain) NSString *periodicDiscount;
@property (nonatomic, retain) NSString *enterpriseCredit;
@property (nonatomic, retain) NSString *commercialContract;
@property (nonatomic, retain) NSString *totalContract;

@property (nonatomic, retain) NSString *grossIncome;
@property (nonatomic, retain) NSString *brutIncome;
@property (nonatomic, retain) NSString *pointToPoint;
@property (nonatomic, retain) NSString *transferedCost;
@property (nonatomic, retain) NSString *grossProceeds;
@property (nonatomic, retain) NSString *grossPercentageWithoutOTV;
@property (nonatomic, retain) NSString *grossPercentageWithOTV;
@property (nonatomic, retain) NSString *estimatedTargetLitre;



@end
