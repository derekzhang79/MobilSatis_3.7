//
//  CSFinancialReport.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 09.05.2013.
//
//

#import "CSFinancialReport.h"

@implementation CSFinancialReport
@synthesize acikSiparisLitre, abankTutar, malGrubuLitreleri, acikKalanTutar, akKrediTutar, ekKrediTutar, ekLimitTutar;
@synthesize eTeminatTutar, kanunTakTutar, kulToplamTutar, malLimitTutar, musteriAdi, musteriNo, sipToplamTutar, toplamBorcTutar, toplamEfesBorcTutar, toplamTeminatTutar, tpKrediTutar, tplRiskTutar, vgcCekTutar, vgcSenetTutar, vgcTalimatTutar, vgcToplamTutar, yeniSiparisToplamTutar, acikSiparisTutar, vglCekTutar, vglSenetTutar, vglTalimatTutar, vglToplamTutar, isFilled;

- (id)initWithArray {
    self = [super init];
    self.malGrubuLitreleri = [[NSMutableArray alloc] init];
    self.isFilled = NO;
    
    return self;
}
@end
