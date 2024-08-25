//
//  IndicatorSettingViewModel+Enum.h
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/27/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Main Category

typedef NSString *IndiSetMainCategory NS_TYPED_ENUM;
NSArray <NSString *>* AllCasesIndiSetMainCategory(void);
static IndiSetMainCategory const IndiSetMainCategoryIndicators = @"지표";
static IndiSetMainCategory const IndiSetMainCategorySignals = @"신호";
static IndiSetMainCategory const IndiSetMainCategoryPatterns = @"패턴";
static IndiSetMainCategory const IndiSetMainCategoryRanges = @"구간";
static IndiSetMainCategory const IndiSetMainCategoryFill = @"채움";
static IndiSetMainCategory const IndiSetMainCategoryFavorites = @"즐겨찾기";


// MARK: - Sub Category

typedef NSString * IndiSetSubCategoryIndica NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetSubCategoryIndica(void);
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaPrice = @"가격지표"; // Price Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaMomentum = @"모멘텀지표"; // Momentum Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaVolatility = @"변동성지표"; // Volatility Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaChannel = @"채널지표"; // Channel Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaTrend = @"추세지표"; // Trend Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaMarketStrength = @"시장강도지표"; // Market Strength
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaVolume = @"거래량지표"; // Volume Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaOther = @"기타지표"; // Other Indicator
static IndiSetSubCategoryIndica const IndiSetSubCategoryIndicaInvestor = @"투자자지표"; // Investor Indicator


typedef NSString * IndiSetSubCategorySignals NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetSubCategorySignals(void);
static IndiSetSubCategorySignals const IndiSetSubCategorySignalsAnalysis = @"분석신호"; // Analysis Signal
static IndiSetSubCategorySignals const IndiSetSubCategorySignalsTrading = @"매매신호"; // Trading Signal

typedef NSString * IndiSetSubCategoryPatterns NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetSubCategoryPatterns(void);
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsBullRev = @"상승반전패턴"; // Bullish Reversal Pattern
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsBullCont = @"상승지속패턴"; // Bullish Continuation Pattern
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsBearRev = @"하락반전패턴"; // Bearish Reversal Pattern
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsBearCont = @"하락지속패턴"; // Bearish Continuation Pattern
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsSideways = @"횡보구간패턴"; // Sideways Range Pattern
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsBoxTrend = @"박스장세패턴"; // Box Trend Pattern
static IndiSetSubCategoryPatterns const IndiSetSubCategoryPatternsTrend = @"추세패턴"; // Trend Pattern


typedef NSString * IndiSetSubCategoryFill NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetSubCategoryFill(void);
static IndiSetSubCategoryFill const IndiSetSubCategoryFillPriceRange = @"가격영역채움"; // Price Range
static IndiSetSubCategoryFill const IndiSetSubCategoryFillVolumeRange = @"거래량영역채움"; // Volume Range
static IndiSetSubCategoryFill const IndiSetSubCategoryFillAnalysisRange = @"분석영역채움"; // Analysis Area


// MARK: - Detail Category: 현재 609개

/// 지표 - 가격지표 30개
typedef NSString * IndiSetDeCateIndicaPrice NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaPrice(void);
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceBollingerBands = @"BollingerBands";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceHLMA = @"고저이동평균"; // HighLowMovingAverage
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceCFTPP = @"CFTPP";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceDEMA = @"DEMA";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceDemark = @"Demark";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceDetrend = @"Detrend";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceEnvelope = @"Envelope";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceIchimoku = @"일목균형지표"; // Ichimoku
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceMovingAverage = @"MovingAverage";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceMAEnvelope = @"MAEnvelope";

static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceMedianPrices = @"MedianPrices";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPricePivot = @"Pivot";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPricePriceChannel = @"PriceChannel";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceProjectionBand = @"ProjectionBand";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPricePSar = @"PSar";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceStdDevBands = @"표준오차밴드"; // StandardDeviationBands
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceTEMA = @"TEMA";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceTypicalPrices = @"TypicalPrices";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceVIDYA = @"VIDYA";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceWeightedCloses = @"WeightedCloses";

static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceZigZag = @"ZigZag";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPricePriceMA = @"가격이동평균"; // Price Moving Average
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceSMA = @"이평그물지표"; // Smoothed Moving Average
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceHighLowLine = @"시고저라인"; // High Low Line
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceMcginleyDynamic = @"McGinley_Dynamic";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceMovingAverageChannels = @"MovingAverageChannels";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceLinearRegressionIndex = @"LinearRegressionIndex";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceKeltnerChannels = @"KeltnerChannels";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPriceCBO = @"CBO";
static IndiSetDeCateIndicaPrice const IndiSetDeCateIndicaPricePriceHighLowIndex = @"PriceHighLowIndex";


/// 지표 - 모멘텀지표- 58개
typedef NSString * IndiSetDeCateIndicaMomentum NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaMomentum(void);
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumAccumSwingIndex = @"AccumSwingIndex";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumCCI = @"CCI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumChaikinOscillator = @"ChaikinOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumROC = @"이격도"; // Rate of Change
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumDPO = @"DPO";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumDX = @"DX";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumEnergyIndex = @"EnergyIndex";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumErayBull = @"ErayBull";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumErayBear = @"ErayBear";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumIMI = @"IMI";

static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMACD = @"MACD";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMACDOscillator = @"MACDOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMassIndex = @"MassIndex";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMomentum = @"Momentum";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumNetChangeOscillator = @"NetChangeOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumPriceOscillator = @"PriceOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumPriceOSCPct = @"PriceOSCPct";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumProjectionBandwidth = @"ProjectionBandwidth";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumProjectionOscillator = @"ProjectionOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumPVO = @"PVO";

static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumPriceROC = @"PriceROC";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumLinearRegressionSlope = @"LinearRegressionSlope";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumRMI = @"RMI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumRSI = @"RSI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumRWI = @"RWI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumStochasticFast = @"StochasticFast";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumStochasticSlow = @"StochasticSlow";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumStochFastOsc = @"StochasticFast_OSC";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumStochRSI = @"StochRSI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumSwingIndex = @"SwingIndex";

static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumTSI = @"TSI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumUltimateOscillator = @"UltimateOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumVolumeROC = @"VolumeROC";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumWilliamsR = @"WilliamsR";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBandB = @"Band%B";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumPriceChangeLine = @"PriceChangeLine";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBPDLHiLo = @"BPDL_HiLoIndex";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBPDLRSI = @"BPDL_RSI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBPDLTrendFilterRaw = @"BPDL_TrendFilter-Raw";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMorrisMixedMomentum = @"Morris_MixedMomentum";

static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMACDSAR = @"MACD_SAR";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumOnBalancePrice = @"OnBalancePrice";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumArmsEaseOfMovement = @"ArmsEaseOfMovement";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBandWidth = @"BandWidth";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumEOM = @"EOM";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumHighLowOscillator = @"HighLowOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumMorrisDailyPressure = @"Morris_DailyPressure";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumNorthPriceActionLine = @"NorthPriceActionLine";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumReverse = @"Reverse";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumVelocityIndex = @"VelocityIndex";

static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumVolumeOscillator = @"VolumeOscillator";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBostiansIntradayIntensityIndex = @"BostiansIntradayIntensityIndex";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumBPDLShortTrend = @"BPDL_ShortTrend";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumLinearRegressionConst = @"LinearRegressionConst";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumROCN = @"이격도(N)";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumRSIOld = @"구RSI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumVPCI = @"VPCI";
static IndiSetDeCateIndicaMomentum const IndiSetDeCateIndicaMomentumVolumeWeightedAvgPrice = @"VolumeWeightedAvgPrice";


/// 지표 - 변동성지표 - 19개
typedef NSString * IndiSetDeCateIndicaVolatility NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaVolatility(void);
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityAverageTrueRange = @"AverageTrueRange";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityBollingerWidth = @"BollingerWidth";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityChaikinVolatility = @"ChaikinVolatility";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityDiffRatio = @"DiffRatio";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityDiffValue = @"DiffValue";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityDispersion = @"Dispersion";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityNeoPsychology = @"NeoPsychology";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityPerformancePct = @"PerformancePct";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityRVI = @"RVI"; // Relative Volatility Index
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityStandardDeviation = @"표준편차"; // Standard Deviation

static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityStandardError = @"표준오차";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityTrueRange = @"TrueRange";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityTrendScore = @"TrendScore";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityWellesSum = @"WellesSum";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityOpenDifference = @"OpenDifference";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityVolumePriceInSync = @"Volume&PriceInSync";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityABRatio = @"ABRatio";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityRVIoriginal = @"RVIoriginal";
static IndiSetDeCateIndicaVolatility const IndiSetDeCateIndicaVolatilityRelativeVigorIndex = @"RelativeVigorIndex"; // Relative Vigor Index


/// 지표 - 채널지표 - 10개
typedef NSString * IndiSetDeCateIndicaChannel NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaChannel(void);
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelAR = @"AR";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelBOP = @"BOP";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelBR = @"BR";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelCMO = @"CMO";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelMesaSineWave = @"MesaSineWave";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelNMO = @"NMO";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelRangeIndicator = @"RangeIndicator";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelSMI = @"SMI";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelEMV = @"EMV";
static IndiSetDeCateIndicaChannel const IndiSetDeCateIndicaChannelBinaryWaveMACD = @"BinaryWaveMACD";


/// 지표 - 추세지표 - 27개
typedef NSString * IndiSetDeCateIndicaTrend NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaTrend(void);
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendADX = @"ADX";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendADXR = @"ADXR";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendAroon = @"Aroon";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendAroonOSC = @"AroonOSC";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendDMI = @"DMI";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendDynamicMI = @"DynamicMI";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendForecastOscillator = @"ForecastOscillator";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendMovingSum = @"MovingSum";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendPFE = @"PFE";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendQstickOscillator = @"QstickOscillator";

static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendSonarMomentum = @"SonarMomentum";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendT3 = @"T3";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendTRIX = @"TRIX";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendVHF = @"VHF";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendAnnualPercentChange = @"AnnualPercentChange";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendBigMovesOnly = @"BigMovesOnly";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendPringsKSTUserArithmetic = @"PringsKST(User-Arithmetic)";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendPringsLongKSTMonthly = @"PringsLongKST-Monthly";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendPringsLongKSTWkly = @"PringsLongKST-Wkly";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendPringsMedKSTWklyEMA = @"PringsMedKST(Wkly-EMA)";

static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendSmoothedROC = @"SmoothedROC";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendTrendex = @"Trendex";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendTSF = @"TSF";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendMovingAverageOscillator = @"MovingAverageOscillator";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendBWI = @"BWI";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendRankCorrelationIndex = @"RankCorrelationIndex";
static IndiSetDeCateIndicaTrend const IndiSetDeCateIndicaTrendStochasticSlowOSC = @"StochasticSlow_OSC";


/// 지표 - 시장강도지표 - 19개
typedef NSString * IndiSetDeCateIndicaMarketStrength NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaMarketStrength(void);
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthAccumDistribution = @"AccumDistribution";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthBSI = @"BSI";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthCSIndex = @"CSIndex";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthDemandIndex = @"DemandIndex";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthDownAverage = @"DownAverage";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthForceIndex = @"ForceIndex";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthInertia = @"Inertia";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthKlingerOscillator = @"KlingerOscillator";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthMoneyFlowIndex = @"MoneyFlowIndex";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthPsychologyIndex = @"신심리도";

static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthOmegaIndex = @"OmegaIndex";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthInvestorPsychologyLine = @"투자심리선";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthPVRank = @"PVRank";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthPVT = @"PVT";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthUpAverage = @"UpAverage";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthWilliamsAccumDist = @"WilliamsAccumDist";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthBPDLStochastic = @"BPDL_Stochastic";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthCompuTracVolatility = @"CompuTracVolatility";
static IndiSetDeCateIndicaMarketStrength const IndiSetDeCateIndicaMarketStrengthPluralityIndex = @"PluralityIndex";


/// 지표 - 거래량지표 - 27개
typedef NSString * IndiSetDeCateIndicaVolume NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaVolume(void);
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeCMF = @"ChaikinMoneyFlow";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeMF = @"MarketFacilitation";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeNVI = @"NegativeVolumeIndex";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeOBV = @"OBV";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeOBVolMv = @"OBVolMv";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumePVI = @"PositiveVolumeIndex";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeVAO = @"VAO";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeVolumeRatio = @"VolumeRatio";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeVolume = @"거래량";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeVolumeMA = @"거래량이동평균";

static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeTradingVolume = @"거래대금";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeGMMMcClellanOsc = @"GMMcClellanOscillator";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeGMMMcClellanSum = @"GMMcClellanSummation";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeBPDLMcClellanSum = @"BPDL_RelativeVolumeIndex";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeDailyVolumeIndex = @"DailyVolumeIndex";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeMorrisIntradayAcc = @"Morris_IntradayAccumulator";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeMovingBalanceInd = @"MovingBalanceIndicator";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeOBVwithAvgVol = @"OBVwithAverageVolume";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeOBVMidpoint = @"OBVMidpoint";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeOBVOscillator = @"OBVOscillator";

static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeSmoothAccumDist = @"SmoothAccumDist";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeSpecialAccumDist = @"SpecialAccumDist";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeDysartVolume = @"DysartVolume";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeVolPctPlusMinusAvg = @"Volume%Plus-minusAVG";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeVolStdDev = @"VolumeStdDeviation";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeDailyAccumVolume = @"일간누적거래량";
static IndiSetDeCateIndicaVolume const IndiSetDeCateIndicaVolumeDailyAccumTradingValue = @"일간누적거래대금";


/// 지표 - 기타지표 - 19개
typedef NSString * IndiSetDeCateIndicaOther NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateIndicaOther(void);
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherBinaryWave = @"BinaryWave";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherPriceTradeCorrelation = @"가격거래상관분석";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherPriceTradeCovariance = @"가격거래공분산";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherStochasticClose = @"StochasticClose";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherWellesVolatilitySIC = @"WellesVolatilitySIC";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherWellesVolatilityARC = @"WellesVolatilityARC";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherWellesVolatilitySAR = @"WellesVolatilitySAR";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherPriceTradeDecisionAnalysis = @"가격거래결정분석";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherPriceTradeBetaAnalysis = @"가격거래베타분석";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherHighLowEnvelope = @"HighLowEnvelope";

static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherLinearTrendOscillator = @"LinearTrendOscillator";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherSigma = @"Sigma";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherPriceSlope = @"SlopeOfPrice";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherVolumeSlope = @"SlopeOfVolume";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherSmoothedMomentum = @"SmoothedMomentum";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherStochasticFastClose = @"StochasticFast_Close";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherStochasticSlowClose = @"StochasticSlow_Close";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherVolumePriceAccum = @"Volume&PriceAccum";
static IndiSetDeCateIndicaOther const IndiSetDeCateIndicaOtherRSquared = @"R-Squared";

/// 신호 - 분석신호 - 126개
typedef NSString * IndiSetDeCateSignAnal NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateSignAnal(void);
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEmaGoldenCross = @"이평골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEmaDeathCross = @"이평데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDisparityOverboughtEntry = @"이격도과열진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDisparityOverboughtExit = @"이격도과열이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDisparityOversoldExit = @"이격도침체이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDisparityOversoldEntry = @"이격도침체진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEmaPriceAboveCross = @"이평가격상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEmaPriceBelowCross = @"이평가격하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCmfOverboughtEntry = @"투자심리도과열진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCmfOverboughtExit = @"투자심리도과열이탈";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCmfOversoldEntry = @"투자심리도침체진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCmfOversoldExit = @"투자심리도침체이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalAroonDeathCross = @"Aroon데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalAroonGoldenCross = @"Aroon골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCciOverboughtEntry = @"CCI과매도진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCciOverboughtExit = @"CCI과매도이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCciOversoldExit = @"CCI과매수이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCciOversoldEntry = @"CCI과매수진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDmiGoldenCross = @"DMI골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDmiDeathCross = @"DMI데드크로스";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEiGoldenCross = @"EnergyIndex골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEiDeathCross = @"EnergyIndex데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCciThresholdUpwardBreak = @"CCI기준값상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCciThresholdDownwardBreak = @"CCI기준값하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMesaSineGoldenCross = @"MesaSine골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMesaSineDeathCross = @"MesaSine데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPsarPriceUpwardBreak = @"Psar가격상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPsarPriceDownwardBreak = @"Psar가격하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalRsiOverboughtEntry = @"RSI과열구간진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalRsiOverboughtExit = @"RSI과열구간이탈";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalRsiOversoldExit = @"RSI침체구간이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalRsiOversoldEntry = @"RSI침체구간진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalRwiBullishReversal = @"RWI강세전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalRwiBearishReversal = @"RWI약세전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticFastOverboughtExit = @"StochasticFast과열이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticFastOverboughtEntry = @"StochasticFast과열진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticFastOversoldExit = @"StochasticFast침체이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticFastOversoldEntry = @"StochasticFast침체진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticSlowOverboughtExit = @"StochasticSlow과열이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticSlowOverboughtEntry = @"StochasticSlow과열진입";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticSlowDivergenceEntry = @"StochasticSlow침체진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticSlowDivergenceExit = @"StochasticSlow침체이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMacdThresholdCrossAbove = @"MACD기준값상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMacdThresholdCrossBelow = @"MACD기준값하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMomentumBullishReversal = @"Momentum강세전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMomentumBearishReversal = @"Momentum약세전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalTrendScoreBullishReversal = @"TrendScore강세전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalTrendScoreBearishReversal = @"TrendScore약세전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalTrixThresholdCrossAbove = @"Trix기준값상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalTrixThresholdCrossBelow = @"Trix기준값하향돌파";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalUpDownAvgGoldenCross = @"UpDownAVG골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalUpDownAvgDeathCross = @"UpDownAVG데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalWilliamsRBuyEntry = @"WilliamsR과매수진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalWilliamsRBuyExit = @"WilliamsR과매수이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalWilliamsRSellExit = @"WilliamsR과매도이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalWilliamsRSellEntry = @"WilliamsR과매도진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalZigzagBearishReversal = @"Zigzag하락전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalZigzagBullishReversal = @"Zigzag상승전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalBollingerBandUpperBreakout = @"BollingerBand상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalBollingerBandLowerBreakout = @"BollingerBand하향돌파";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticFastDeathCross = @"StochasticFast데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticFastGoldenCross = @"StochasticFast골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDisparityGoldenCross = @"이격도간골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDisparityDeathCross = @"이격도간데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalContinuousPriceRise = @"주가연속상승";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalContinuousPriceFall = @"주가연속하락";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalBinaryWaveBuySignal = @"BinaryWave기준값매수";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDiPlusCrossesAboveDIMinus = @"DI+가 DI-를 상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalDiPlusCrossesBelowDIMinus = @"DI+가 DI-를 하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEomSignalLineCrossesAbove = @"EOM기준선 상향돌파";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEomSignalLineCrossesBelow = @"EOM기준선 하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMfiOverboughtZoneEntry = @"MFI과열권진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMfiOverboughtZoneExit = @"MFI과열권이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalTrixSignalGoldenCross = @"TRIX-sig 골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalTrixSignalDeathCross = @"TRIX-sig 데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMacdSignalGoldenCross = @"MACD-sig와 골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMacdSignalDeathCross = @"MACD-sig와 데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMfiOversoldZoneEntry = @"MFI침체권진입";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMfiOversoldZoneExit = @"MFI침체권이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuCloudEntry = @"일목균형구름진입";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuCloudExit = @"일목균형구름이탈";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuCloudInside = @"일목균형주가구름내부";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuBaseLineLeadingSpan1CrossAbove = @"일목기준선선행스팬1상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuBaseLineLeadingSpan1CrossBelow = @"일목기준선선행스팬1하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuBaseLineLeadingSpan2CrossAbove = @"일목기준선선행스팬2상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuBaseLineLeadingSpan2CrossBelow = @"일목기준선선행스팬2하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuLeadingSpan12GoldenCross = @"일목선행스팬12골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuLeadingSpan12DeathCross = @"일목선행스팬12데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuConversionLineLeadingSpan1CrossAbove = @"일목전환선선행스팬1상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuConversionLineLeadingSpan1CrossBelow = @"일목전환선선행스팬1하향돌파";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuConversionLineLeadingSpan2CrossAbove = @"일목전환선선행스팬2상향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalIchimokuConversionLineLeadingSpan2CrossBelow = @"일목전환선선행스팬2하향돌파";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceRateOfChangeContinousNDays = @"가격 변화율(N일연속)";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceDecline = @"가격급락";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceAdvance = @"가격급등";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalAverageVolumeOverNPeriodsMWeeks = @"N일평균거래량M주이상";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalVolumeDecline = @"거래량급감";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalVolumeAdvance = @"거래량급증";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalVolumeHighRenewal = @"거래량최고치갱신";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalVolumeLowRenewal = @"거래량최저치갱신";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPeriodHigh = @"기간내최고가";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPeriodLow = @"기간내최저가";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalNoTradingStock = @"무거래종목";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalNewHigh = @"신고가";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalNewLow = @"신저가";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageUpturn = @"이동평균선상승전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageDownturn = @"이동평균선하락전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageSupportLineNear = @"이평지지선근접";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageResistanceLineNear = @"이평저항선근접";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageConvergence = @"이평선밀집";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageConvergenceUptrend = @"이평선밀집후상승전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalMovingAverageConvergenceDowntrend = @"이평선밀집후하락전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceSideways = @"주가횡보";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceSidewaysUptrend = @"주가횡보후상승전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceSidewaysDowntrend = @"주가횡보후하락전환";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceMovingAverageConvergence = @"주가이동평균밀집";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceMovingAverageInverted = @"주가이평역배열";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalPriceMovingAverageRegular = @"주가이평정배열";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalObvSignalGoldenCross = @"OBV-sig와 골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalObvSignalDeathCross = @"OBV-sig와 데드크로스";

static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalCeilingPrice = @"상한가";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalFloorPrice = @"하한가";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticSlowGoldenCross = @"StochasticSlow골든크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalStochasticSlowDeathCross = @"StochasticSlow데드크로스";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalEilingPrice30Percent = @"상한가(30%)";
static IndiSetDeCateSignAnal const IndiSetDeCateSignAnalLoorPrice30Percent = @"하한가(30%)";


/// 신호 - 매매신호 - 32개
typedef NSString * IndiSetDeCateSignTrading NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateSignTrading(void);
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingInsideDayBuy = @"InsideDay매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingInsideDaySell = @"InsideDay매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingPlan7percentBuy = @"7%Plan매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingPlan7percentSell = @"7%Plan매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingBuy180s = @"180's매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingSell180s = @"180's매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingGilligansIslandBuy = @"Gilligan'sIsland매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingGilligansIslandSell = @"Gilligan'sIsland매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingLizardsBuy = @"Lizards매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingLizardsSell = @"Lizards매도";

static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingOops10PercentBuy = @"10%Oops매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingOops10PercentSell = @"10%Oops매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingSlingShotsBuy = @"SlingShots매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingSlingShotsSell = @"SlingShots매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingSpentMarketTradingPatternBuy = @"SpentMarketTradingPattern매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingSpentMarketTradingPatternSell = @"SpentMarketTradingPattern매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingExtendedLevelBoomersBuy = @"ExtendedLevelBoomers매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingExtendedLevelBoomersSell = @"ExtendedLevelBoomers매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingPivotPointBuy = @"PivotPoint매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingPivotPointSell = @"PivotPoint매도";

static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingOutsideDayBuy = @"OutsideDay매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingOutsideDaySell = @"OutsideDay매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingOneTwoThreeFourBuy = @"1-2-3-4's매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingOneTwoThreeFourSell = @"1-2-3-4's매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingExpansionPivotsBuy = @"ExpansionPivots매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingExpansionPivotsSell = @"ExpansionPivots매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingBoomersBuy = @"Boomers매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingBoomersSell = @"Boomers매도";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingAdxGapperBuy = @"ADXGapper매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingAdxGapperSell = @"ADXGapper매도";

static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingJackInTheBoxStrategyBuy = @"Jack-in-the-boxStrategy매수";
static IndiSetDeCateSignTrading const IndiSetDeCateSignTradingJackInTheBoxStrategySell = @"Jack-in-the-boxStrategy매도";


/// 패턴 - 상승반전패턴 - 27개
typedef NSString * IndiSetDeCatePatBulRever NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCatePatBulRever(void);
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishHammer = @"강세비석형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishInvertedHammer = @"강세잠자리형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverPiercingPattern = @"관툥형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverIdenticalLows = @"동일저점형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverIdenticalThreeCrows = @"동일흑삼병형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishEngulfing = @"막대샌드위치형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverLadderBottom = @"사다리바닥형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverRisingSunDoji = @"상승기아형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverRisingFallingThreeMethods = @"상승박차형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishCounterattack = @"상승반격형";

static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishKicker = @"상승샅바형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishThreeWhiteSoldiers = @"상승세십자형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishStalledPattern = @"상승십자잉태형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishKickback = @"상승잉태형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishConfirmedKickback = @"상승잉태확인형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishEngulfingHarami = @"상승장악형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishConfirmedEngulfingHarami = @"상승장악확인형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishEscape = @"상승탈출형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverMorningStar = @"샛별형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishMorningDojiStar = @"십자샛별형";

static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBabySwallow = @"애기제비감추기형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishThreeLineStrike = @"약세삼선반격형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBullishHammerInvertedHammer = @"역망치형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverBearishThreeBlackCrows = @"적삼병";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverMorningDojiStar = @"전서구형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverTweezerBottom = @"집게바닥형";
static IndiSetDeCatePatBulRever const IndiSetDeCatePatBulReverRareThreeRiverBottom = @"희귀삼천바닥형";


/// 패턴 - 상승지속패턴 - 10개
typedef NSString * IndiSetDeCatePatBullConti NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCatePatBullConti(void);
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishThreeLineStrike = @"강세삼선반격형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiMatHold = @"매트형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBlockPattern = @"블록형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishFork = @"상승갈림길형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishGapThreeMethods = @"상승갭삼법형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishSideBySideWhiteLines = @"상승나란히형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishThreeMethods = @"상승삼법형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishTasukiGap = @"상승타스키갭형";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiBullishLongWhiteCandle = @"장양봉";
static IndiSetDeCatePatBullConti const IndiSetDeCatePatBullContiDelayedPattern = @"지연형";


/// 패턴 - 하락반전패턴 - 24개
typedef NSString * IndiSetDeCatePatBearRever NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCatePatBearRever(void);
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverProfessorPattern = @"교수형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverSouthernStar = @"남상성형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverCrowPattern = @"까마귀형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverHammerPattern = @"망치형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverStoneStar = @"석별형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverCrossStoneStar = @"십자석별형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverWeakCrowPattern = @"약세까마귀형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverWeakStonePattern = @"약세비석형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverWeakInvertedHammer = @"약세잠자리형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverShootingStar = @"유성형";

static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverTweezerTop = @"집게천장형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishAbandonedBaby = @"하락기아형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishFallingThreeMethods = @"하락박차형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishCounterattack = @"하락반격형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishKicker = @"하락샅바형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishThreeBlackCrows = @"하락세십자형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishStalledPattern = @"하락십자잉태형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishKickback = @"하락잉태형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishConfirmedKickback = @"하락잉태확인형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishEngulfingHarami = @"하락장악형";

static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishConfirmedEngulfingHarami = @"하락장악확인형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBearishEscape = @"하락탈출형";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBlackThreeCrows = @"흑삼병";
static IndiSetDeCatePatBearRever const IndiSetDeCatePatBearReverBlackCloudCover = @"흑운형";


/// 패턴 - 하락지속패턴 - 9개
typedef NSString * IndiSetDeCatePatBearConti NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCatePatBearConti(void);
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiThrustingLine = @"ThrustingLine";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiCrossingLine = @"걸침형";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiLongBlackCandle = @"장음봉";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiEntryPattern = @"진입형";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiBearishFork = @"하락갈림길형";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiBearishGapThreeMethods = @"하락갭삼법형";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiBearishSideBySidePattern = @"하락나란히형";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiBearishThreeMethods = @"하락삼법형";
static IndiSetDeCatePatBearConti const IndiSetDeCatePatBearContiBearishTasukiGap = @"하락타스키갭형";


/// 패턴 - 횡보구간패턴 - 0개
/// enum IndiSetDeCatePatSidewaysRange: String, Codable, CaseIterable {}

/// 패턴 - 박스장세패턴 - 0개
/// enum IndiSetDeCatePatBoxTrend: String, Codable, CaseIterable {}

/// 패턴 - 추세패턴 - 46개
typedef NSString * IndiSetDeCatePatTrend NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCatePatTrend(void);
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendAttemptedRecoveryAfter2Declines = @"2연속하락후반등시도";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendConsecutiveRises2 = @"2연속상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendConsecutiveDeclines2 = @"2연속하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendAttemptedRecoveryAfter3Declines = @"3연속하락후반등시도";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendConsecutiveRises3 = @"3연속상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendConsecutiveDeclines3 = @"3연속하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendConsecutiveRises4 = @"4연속상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendConsecutiveDeclines4 = @"4연속하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendMPattern = @"M자형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendTwinPeaksPattern = @"쌍봉형";

static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendVBottomPattern = @"V바닥형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendAsymmetricVBottomPattern = @"비대칭V바닥형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendExpandedVBottomPattern = @"V바닥형확장";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendVTopPattern = @"V천정형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendExpandedVTopPattern = @"V천정형확장";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendAsymmetricVTopPattern = @"비대칭V천정형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendExpandedAsymmetricVBottomPattern = @"비대칭V바닥형확장";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendExpandedAsymmetricVTopPattern = @"비대칭V천정형확장";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendWPattern = @"W자형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendInvertedTwinPeaksPattern = @"역쌍봉형";

static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishAscendingTriangle = @"강세이동삼각";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendHeadAndShouldersPattern = @"머리어깨형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendFailedRally = @"반등실패";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishFlag = @"상승사각깃발";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishRectangle = @"상승직사각형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishConsolidationThenBearish = @"상승횡보후하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishAfter2ConsecutiveDeclines = @"상승후2연속하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBearishDescendingTriangle = @"약세이동삼각";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendInvertedHeadAndShouldersPattern = @"역머리어깨형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendDoubleBottomPattern = @"이중바닥형";

static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendDoubleTopPattern = @"이중천정형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendSidewaysAdjustmentThen2Rises = @"횡보조정후2연속상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendSidewaysConsolidationThenBullish = @"횡보조정후상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendRecoveryAfterCorrection = @"조정후재상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBearishRectangle = @"하락직사각형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishConsolidationThenRise = @"하락횡보후상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishAfter2ConsecutiveRises = @"하락후2연속상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendExpandedTriangle = @"확장삼각형";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendSidewaysConsolidationThen2Rises = @"횡보후2연속상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendSidewaysConsolidationThen2Declines = @"횡보후2연속하락";

static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendSidewaysConsolidationThenRise = @"횡보후상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBullishConsolidationThenRecovery = @"상승횡보후재상승";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendBearishConsolidationThenSharpDecline = @"하락횡보후재하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendSidewaysConsolidationThenDecline = @"횡보후하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendRecoveryAfterSharpDecline = @"조정후재하락";
static IndiSetDeCatePatTrend const IndiSetDeCatePatTrendFailedBreakdown = @"반락실패";


/// 구간 74개
typedef NSString * IndiSetDeCateRange NS_TYPED_EXTENSIBLE_ENUM; // 74
NSArray <NSString *>* AllCasesIndiSetDeCateRange(void);
static IndiSetDeCateRange const IndiSetDeCateRangeOverbought = @"이격도과열구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOversold = @"이격도침체구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongTrendBetweenMovingAverages = @"이평간강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakTrendBetweenMovingAverages = @"이평간약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongTrendBetweenPriceAndMovingAverages = @"이평가격간강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakTrendBetweenPriceAndMovingAverages = @"이평가격간약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOverboughtInvestorSentiment = @"투자심리도기준값과열";
static IndiSetDeCateRange const IndiSetDeCateRangeOversoldInvestorSentiment = @"투자심리도기준값침체";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongAroon = @"Aroon강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakAroon = @"Aroon약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeOverboughtCCI = @"CCI과매도구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOversoldCCI = @"CCI과매수구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongDMI = @"DMI강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakDMI = @"DMI약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongMACDLine = @"MACD기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakMACDLine = @"MACD기준선약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeBullishMACDCrossover = @"MACD크로스강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeBearishMACDCrossover = @"MACD크로스약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongMomentum = @"Momentum강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakMomentum = @"Momentum약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeWeakMomentumBaseline = @"Momentum기준선약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongMomentumBaseline = @"Momentum기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongParabolicSAR = @"PSar가격강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakParabolicSAR = @"PSar가격약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOverboughtRSI = @"RSI과열구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOversoldRSI = @"RSI침체구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongRSI = @"RSI기준값강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakRSI = @"RSI기준값약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongTRIX = @"TRIX기준값강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakTRIX = @"TRIX기준값약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeStrongTRIXBaseline = @"TRIX기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakTRIXBaseline = @"TRIX기준선약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongADXBaseline = @"ADX기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakADXBaseline = @"ADX기준선약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongEnergyIndex = @"EnergyIndex강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakEnergyIndex = @"EnergyIndex약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongMesaSineWave = @"MesaSineWave강세";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakMesaSineWave = @"MesaSineWave약세";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongRWI = @"RWI강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakRWI = @"RWI약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeBullishZigZag = @"ZigZag상승구간";
static IndiSetDeCateRange const IndiSetDeCateRangeBearishZigZag = @"ZigZag하락구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOverboughtWilliamsR = @"WilliamsR과매도영역";
static IndiSetDeCateRange const IndiSetDeCateRangeOversoldWilliamsR = @"WilliamsR과매수영역";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongUpDownAVG = @"UpDownAVG강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakUpDownAVG = @"UpDownAVG약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongTrendScore = @"TrendScore강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakTrendScore = @"TrendScore약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongStochasticFast = @"StochasticFast강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakStochasticFast = @"StochasticFast약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeStrongStochasticSlow = @"StochasticSlow강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakStochasticSlow = @"StochasticSlow약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongABRatio = @"AB-Ratio강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakABRatio = @"AB-Ratio약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongBinaryWave = @"BinaryWave강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakBinaryWave = @"BinaryWave약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOverboughtChaikinsOscillator = @"Chaikin'sOscillator과열구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOversoldChaikinsOscillator = @"Chaikin'sOscillator침체구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongEOM = @"EOM강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakEOM = @"EOM약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeStrongNetChangeOscillator = @"NetChangeOscillator강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakNetChangeOscillator = @"NetChangeOscillator약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongNVI = @"NVI기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakNVI = @"NVI기준선약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongPVI = @"PVI기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakPVI = @"PVI기준선약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongPriceROC = @"PriceROC강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakPriceROC = @"PriceROC약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeStrongSonar = @"Sonar기준선강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakSonar = @"Sonar기준선약세구간";

static IndiSetDeCateRange const IndiSetDeCateRangeStrongVR = @"VR강세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeWeakVR = @"VR약세구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOverboughtMFI = @"MFI과열구간";
static IndiSetDeCateRange const IndiSetDeCateRangeOversoldMFI = @"MFI침체구간";


/// 채움 - 가격영역채움 - 28개
typedef NSString * IndiSetDeCateFillPrice NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateFillPrice(void);
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceBollingerBand = @"BollingerBand채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceCFTPPFirst = @"CFTPP1차채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceCFTPPSecond = @"CFTPP2차채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceDema = @"DEMA채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceEnvelope = @"Envelope채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePriceMovingAverage = @"가격이동평균채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePriceMovingAverageBetween = @"가격이동평균간채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePriceChannel = @"PriceChannel채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePriceHighLow = @"PriceHighLow채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceProjectionBand = @"ProjectionBand채움";

static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePsar = @"PSar채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceTema = @"TEMA채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceVidya = @"VIDYA채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceZigzag = @"ZigZag채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceHighLow = @"고저채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceIchimokuConversionLine = @"일목균형지표전환기준선채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceIchimokuBaseLine = @"일목균형지표전환선채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceIchimokuLeadingSpanA = @"일목균형지표기준선채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceStandardDeviationBands = @"표준오차밴드채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceMovingAverageHighestLowest = @"이평최상최하채움";

static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceMovingAverageUpperLower = @"이평상하채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceMaEnvelope = @"MAEnvelope채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceLinearRegIndexSignal = @"LinearRegIndexSignal채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceCBO = @"CBO채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceKeltnerChannels = @"KeltnerChannels채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePivotFirst = @"Pivot1차채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPricePivotSecond = @"Pivot2차채움";
static IndiSetDeCateFillPrice const IndiSetDeCateFillPriceDemark = @"Demark채움";


/// 채움 - 거래량영역채움 - 2개
typedef NSString * IndiSetDeCateFillVolume NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateFillVolume(void);
static IndiSetDeCateFillVolume const IndiSetDeCateFillVolumeMovingAverageBetween = @"거래량이동평균간채움";
static IndiSetDeCateFillVolume const IndiSetDeCateFillVolumeMovingAverage = @"거래량이동평균채움";

/// 채움 - 분석영역채움 - 22개
typedef NSString * IndiSetDeCateFillAnal NS_TYPED_EXTENSIBLE_ENUM;
NSArray <NSString *>* AllCasesIndiSetDeCateFillAnal(void);
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalAroon = @"Aroon채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalCCISignal = @"CCI_Signal채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalElerRay = @"ElerRay채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalMacdSignal = @"MACD_Signal채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalReverse = @"Reverse채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalRSI = @"RSI채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalRsiSignal = @"RSI_Signal채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalStochasticFast = @"StochasticFast채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalStochasticSlow = @"StochasticSlow채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalDivergenceBetween = @"이격도간채움";

static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalAbRatio = @"AB-Ratio채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalOpenDifference = @"OpenDifference채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalRelativeVigorIndex = @"RelativeVigorIndex채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalEnergyIndex = @"EnergyIndex채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalErayBullBear = @"ErayBullBear채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalRWI = @"RWI채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalArBr = @"ArBr채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalMesaSineWave = @"MesaSineWave채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalDMI = @"DMI채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalRankCorrelationIndex = @"RankCorrelationIndex채움";

static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalUpDownAverage = @"UpDownAverage채움";
static IndiSetDeCateFillAnal const IndiSetDeCateFillAnalPviNvi = @"PVI_NVI채움";


//@interface IndicatorSettingViewModel (Enum)
//
//@end

NS_ASSUME_NONNULL_END
