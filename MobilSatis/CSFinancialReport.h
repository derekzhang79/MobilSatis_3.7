//
//  CSFinancialReport.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 09.05.2013.
//
//

#import <Foundation/Foundation.h>

@interface CSFinancialReport : NSObject
{
    NSString *abankTutar;
    NSString *acikSiparisLitre;
    NSString *acikKalanTutar;
    NSString *acikSiparisTutar;
    NSString *akKrediTutar;
    NSString *ekKrediTutar;
    NSString *ekLimitTutar;
    NSString *eTeminatTutar;
    NSString *kanunTakTutar;
    NSString *kulToplamTutar;
    NSMutableArray *malGrubuLitreleri;
    NSString *malLimitTutar;
    NSString *musteriNo;
    NSString *musteriAdi;
    NSString *sipToplamTutar;
    NSString *toplamBorcTutar;
    NSString *toplamEfesBorcTutar;
    NSString *toplamTeminatTutar;
    NSString *tpKrediTutar;
    NSString *tplRiskTutar;
    NSString *vgcCekTutar;
    NSString *vgcSenetTutar;
    NSString *vgcTalimatTutar;
    NSString *vgcToplamTutar;
    NSString *vglCekTutar;
    NSString *vglSenetTutar;
    NSString *vglTalimatTutar;
    NSString *vglToplamTutar;
    NSString *yeniSiparisToplamTutar;
    BOOL isFilled;
}

@property (nonatomic, retain) NSString *abankTutar;
@property (nonatomic, retain) NSString *acikSiparisLitre;
@property (nonatomic, retain) NSString *acikKalanTutar;
@property (nonatomic, retain) NSString *acikSiparisTutar;
@property (nonatomic, retain) NSString *akKrediTutar;
@property (nonatomic, retain) NSString *ekKrediTutar;
@property (nonatomic, retain) NSString *ekLimitTutar;
@property (nonatomic, retain) NSString *eTeminatTutar;
@property (nonatomic, retain) NSString *kanunTakTutar;
@property (nonatomic, retain) NSString *kulToplamTutar;
@property (nonatomic, retain) NSMutableArray *malGrubuLitreleri;
@property (nonatomic, retain) NSString *malLimitTutar;
@property (nonatomic, retain) NSString *musteriNo;
@property (nonatomic, retain) NSString *musteriAdi;
@property (nonatomic, retain) NSString *sipToplamTutar;
@property (nonatomic, retain) NSString *toplamBorcTutar;
@property (nonatomic, retain) NSString *toplamEfesBorcTutar;
@property (nonatomic, retain) NSString *toplamTeminatTutar;
@property (nonatomic, retain) NSString *tpKrediTutar;
@property (nonatomic, retain) NSString *tplRiskTutar;
@property (nonatomic, retain) NSString *vgcCekTutar;
@property (nonatomic, retain) NSString *vgcSenetTutar;
@property (nonatomic, retain) NSString *vgcTalimatTutar;
@property (nonatomic, retain) NSString *vgcToplamTutar;
@property (nonatomic, retain) NSString *vglCekTutar;
@property (nonatomic, retain) NSString *vglSenetTutar;
@property (nonatomic, retain) NSString *vglTalimatTutar;
@property (nonatomic, retain) NSString *vglToplamTutar;
@property (nonatomic, retain) NSString *yeniSiparisToplamTutar;
@property BOOL isFilled;

- (id)initWithArray;
@end
