//
//  IndicatorSettingViewModel.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import UIKit

// MARK: - Main Category

enum IndiSetMainCategory: String, Codable, CaseIterable { // allCases 사용가능
    case indicators = "지표"
    case signals = "신호"
    case patterns = "패턴"
    case ranges = "구간"
    case fill = "채움"
    case favorites = "즐겨찾기"
}

// MARK: - Sub Category

enum IndiSetSubCategoryIndica: String, Codable, CaseIterable { // allCases 사용가능
    case price = "가격지표" // Price Indicator
    case momentum = "모멘텀지표" // Momentum Indicator
    case volatility = "변동성지표" // Volatility Indicator
    case channel = "채널지표" // Channel Indicator
    case trend = "추세지표" // Trend Indicator
    case marketStrength = "시장강도지표" // Market Strength
    case volume = "거래량지표" // Volume Indicator
    case other = "기타지표" // Other Indicator
    case investor = "투자자지표" // Investor Indicator
}

enum IndiSetSubCategorySignals: String, Codable, CaseIterable { // allCases 사용가능
    case analysis = "분석신호" // Analysis Signal
    case trading = "매매신호" // Trading Signal
}

enum IndiSetSubCategoryPatterns: String, Codable, CaseIterable { // allCases 사용가능
    case bullRev = "상승반전패턴" // Bullish Reversal Pattern
    case bullCont = "상승지속패턴" // Bullish Continuation Pattern
    case bearRev = "하락반전패턴" // Bearish Reversal Pattern
    case bearCont = "하락지속패턴" // Bearish Continuation Pattern
    case sideways = "횡보구간패턴" // Sideways Range Pattern
    case boxTrend = "박스장세패턴" // Box Trend Pattern
    case trend = "추세패턴" // Trend Pattern
}

enum IndiSetSubCategoryFill: String, Codable, CaseIterable { // allCases 사용가능
    case priceRange = "가격영역채움" // Price Range
    case volumeRange = "거래량영역채움" // Volume Range
    case analysisRange = "분석영역채움" // Analysis Area
}

// MARK: - Detail Category: 현재 609개

/// 지표 - 가격지표 30개
enum IndiSetDetailCategoryIndicaPrice: String, Codable, CaseIterable { // allCases 사용가능
    case bbands = "BollingerBands"
    case hlma = "고저이동평균" // HighLowMovingAverage
    case cftpp = "CFTPP"
    case dema = "DEMA"
    case demark = "Demark"
    case detrend = "Detrend"
    case envelope = "Envelope"
    case ichimoku = "일목균형지표" // Ichimoku
    case ma = "MovingAverage"
    case maEnvelope = "MAEnvelope"
    
    case medianPrices = "MedianPrices"
    case pivot = "Pivot"
    case priceChannel = "PriceChannel"
    case projectionBand = "ProjectionBand"
    case psar = "PSar"
    case stdDevBands = "표준오차밴드" // StandardDeviationBands
    case tema = "TEMA"
    case typicalPrices = "TypicalPrices"
    case vidya = "VIDYA"
    case weightedCloses = "WeightedCloses"
    
    case zigzag = "ZigZag"
    case priceMA = "가격이동평균" // Price Moving Average
    case sma = "이평그물지표" // Smoothed Moving Average
    case highLowLine = "시고저라인" // High Low Line
    case mcginleyDynamic = "McGinley_Dynamic"
    case maChannels = "MovingAverageChannels"
    case linearRegIndex = "LinearRegressionIndex"
    case keltnerChannels = "KeltnerChannels"
    case cbo = "CBO"
    case priceHighLowIndex = "PriceHighLowIndex"
}

/// 지표 - 모멘텀지표- 58개
enum IndiSetDetailCategoryIndicaMomentum: String, Codable, CaseIterable { // allCases 사용가능
    case asi = "AccumSwingIndex"
    case cci = "CCI"
    case cho = "ChaikinOscillator"
    case roc = "이격도" // Rate of Change
    case dpo = "DPO"
    case dx = "DX"
    case ei = "EnergyIndex"
    case erayBull = "ErayBull"
    case erayBear = "ErayBear"
    case imi = "IMI"
    
    case macd = "MACD"
    case macdOscillator = "MACDOscillator"
    case massIndex = "MassIndex"
    case momentum = "Momentum"
    case netChangeOscillator = "NetChangeOscillator"
    case priceOscillator = "PriceOscillator"
    case priceOscPct = "PriceOSCPct"
    case projBandwidth = "ProjectionBandwidth"
    case projOscillator = "ProjectionOscillator"
    case pvo = "PVO"
    
    case priceRoc = "PriceROC"
    case lrSlope = "LinearRegressionSlope"
    case rmi = "RMI"
    case rsi = "RSI"
    case rwi = "RWI"
    case stochFast = "StochasticFast"
    case stochSlow = "StochasticSlow"
    case stochFastOsc = "StochasticFast_OSC"
    case stochRsi = "StochRSI"
    case swingIndex = "SwingIndex"
    
    case tsi = "TSI"
    case ultOscillator = "UltimateOscillator"
    case volRoc = "VolumeROC"
    case williamsR = "WilliamsR"
    case bandB = "Band%B"
    case priceChangeLine = "PriceChangeLine"
    case bpdlHiLo = "BPDL_HiLoIndex"
    case bpdlRsi = "BPDL_RSI"
    case bpdlTrendRaw = "BPDL_TrendFilter-Raw"
    case morrisMixedMomentum = "Morris_MixedMomentum"
    
    case macdSar = "MACD_SAR"
    case obp = "OnBalancePrice"
    case aem = "ArmsEaseOfMovement"
    case bw = "BandWidth"
    case eom = "EOM"
    case hlo = "HighLowOscillator"
    case morrisDailyPressure = "Morris_DailyPressure"
    case npal = "NorthPriceActionLine"
    case reverse = "Reverse"
    case vi = "VelocityIndex"
    
    case volOscillator = "VolumeOscillator"
    case biIntensityIndex = "BostiansIntradayIntensityIndex"
    case bpdlShortTrend = "BPDL_ShortTrend"
    case lrConst = "LinearRegressionConst"
    case rocN = "이격도(N)"
    case rsiOld = "구RSI"
    case vpci = "VPCI"
    case vwAvgPrice = "VolumeWeightedAvgPrice"
}

/// 지표 - 변동성지표 - 19개
enum IndiSetDetailCategoryIndicaVolatility: String, Codable, CaseIterable { // allCases 사용가능
    case atr = "AverageTrueRange"
    case bollWidth = "BollingerWidth"
    case cv = "ChaikinVolatility"
    case diffRatio = "DiffRatio"
    case diffValue = "DiffValue"
    case dispersion = "Dispersion"
    case neoPsych = "NeoPsychology"
    case perfPct = "PerformancePct"
    case rvoli = "RVI" // Relative Volatility Index
    case stdDev = "표준편차" // Standard Deviation
    
    case stdErr = "표준오차"
    case tr = "TrueRange"
    case ts = "TrendScore"
    case ws = "WellesSum"
    case openDiff = "OpenDifference"
    case vpis = "Volume&PriceInSync"
    case abRatio = "ABRatio"
    case rviOriginal = "RVIoriginal"
    case rvi = "RelativeVigorIndex" // Relative Vigor Index
}

/// 지표 - 채널지표 - 10개
enum IndiSetDetailCategoryIndicaChannel: String, Codable, CaseIterable { // allCases 사용가능
    case ar = "AR"
    case bop = "BOP"
    case br = "BR"
    case cmo = "CMO"
    case mesaSinewave = "MesaSineWave"
    case nmo = "NMO"
    case rangeInd = "RangeIndicator"
    case smi = "SMI"
    case emv = "EMV"
    case bwMacd = "BinaryWaveMACD"
}

/// 지표 - 추세지표 - 27개
enum IndiSetDetailCategoryIndicaTrend: String, Codable, CaseIterable { // allCases 사용가능
    case adx = "ADX"
    case adxr = "ADXR"
    case aroon = "Aroon"
    case aroonOsc = "AroonOSC"
    case dmi = "DMI"
    case dynamicMI = "DynamicMI"
    case forecastOsc = "ForecastOscillator"
    case movingSum = "MovingSum"
    case pfe = "PFE"
    case qstickOsc = "QstickOscillator"
    
    case sonarMomentum = "SonarMomentum"
    case t3 = "T3"
    case trix = "TRIX"
    case vhf = "VHF"
    case annualPctChange = "AnnualPercentChange"
    case bigMovesOnly = "BigMovesOnly"
    case pringsKST = "PringsKST(User-Arithmetic)"
    case pringsLongKSTMonthly = "PringsLongKST-Monthly"
    case pringsLongKSTWkly = "PringsLongKST-Wkly"
    case pringsMedKST = "PringsMedKST(Wkly-EMA)"
    
    case smoothedROC = "SmoothedROC"
    case trendex = "Trendex"
    case tsf = "TSF"
    case maOscillator = "MovingAverageOscillator"
    case bwi = "BWI"
    case rankCorrelationIndex = "RankCorrelationIndex"
    case stochasticSlowOsc = "StochasticSlow_OSC"
}

/// 지표 - 시장강도지표 - 19개
enum IndiSetDetailCategoryIndicaMarketStrength: String, Codable, CaseIterable { // allCases 사용가능
    case accumDistribution = "AccumDistribution"
    case bsi = "BSI"
    case csIndex = "CSIndex"
    case demandIndex = "DemandIndex"
    case downAverage = "DownAverage"
    case forceIndex = "ForceIndex"
    case inertia = "Inertia"
    case klingerOscillator = "KlingerOscillator"
    case moneyFlowIndex = "MoneyFlowIndex"
    case psychologyIndex = "신심리도"
    
    case omegaIndex = "OmegaIndex"
    case investorPsychologyLine = "투자심리선"
    case pvRank = "PVRank"
    case pvt = "PVT"
    case upAverage = "UpAverage"
    case williamsAccumDist = "WilliamsAccumDist"
    case bpdlStochastic = "BPDL_Stochastic"
    case compuTracVolatility = "CompuTracVolatility"
    case pluralityIndex = "PluralityIndex"
}

/// 지표 - 거래량지표 - 27개
enum IndiSetDetailCategoryIndicaVolume: String, Codable, CaseIterable { // allCases 사용가능
    case cmf = "ChaikinMoneyFlow"
    case mf = "MarketFacilitation"
    case nvi = "NegativeVolumeIndex"
    case obv = "OBV"
    case obVolMv = "OBVolMv"
    case pvi = "PositiveVolumeIndex"
    case vao = "VAO"
    case volumeRatio = "VolumeRatio"
    case volume = "거래량"
    case volumeMA = "거래량이동평균"
    
    case tradingVolume = "거래대금"
    case gmmMcClellanOsc = "GMMcClellanOscillator"
    case gmmMcClellanSum = "GMMcClellanSummation"
    case bpdlRelVolIndex = "BPDL_RelativeVolumeIndex"
    case dailyVolIndex = "DailyVolumeIndex"
    case morrisIntradayAcc = "Morris_IntradayAccumulator"
    case movingBalInd = "MovingBalanceIndicator"
    case obvAvgVol = "OBVwithAverageVolume"
    case obvMidpoint = "OBVMidpoint"
    case obvOscillator = "OBVOscillator"
    
    case smoothAccumDist = "SmoothAccumDist"
    case specialAccumDist = "SpecialAccumDist"
    case dysartVolume = "DysartVolume"
    case volPctPlusMinusAvg = "Volume%Plus-minusAVG"
    case volStdDev = "VolumeStdDeviation"
    case dailyAccumVolume = "일간누적거래량"
    case dailyAccumTradingValue = "일간누적거래대금"
}

/// 지표 - 기타지표 - 19개
enum IndiSetDetailCategoryIndicaOther: String, Codable, CaseIterable { // allCases 사용가능
    case binaryWave = "BinaryWave"
    case priceTradeCorrelation = "가격거래상관분석"
    case priceTradeCovariance = "가격거래공분산"
    case stochasticClose = "StochasticClose"
    case wellesVolatilitySIC = "WellesVolatilitySIC"
    case wellesVolatilityARC = "WellesVolatilityARC"
    case wellesVolatilitySAR = "WellesVolatilitySAR"
    case priceTradeDecisionAnalysis = "가격거래결정분석"
    case priceTradeBetaAnalysis = "가격거래베타분석"
    case highLowEnvelope = "HighLowEnvelope"
    
    case linearTrendOscillator = "LinearTrendOscillator"
    case sigma = "Sigma"
    case priceSlope = "SlopeOfPrice"
    case volumeSlope = "SlopeOfVolume"
    case smoothedMomentum = "SmoothedMomentum"
    case stochasticFastClose = "StochasticFast_Close"
    case stochasticSlowClose = "StochasticSlow_Close"
    case volumePriceAccum = "Volume&PriceAccum"
    case rSquared = "R-Squared"
}

/// 신호 - 분석신호 - 126개
enum IndiSetDetailCategorySignalsAnalysis: String, Codable, CaseIterable { // allCases 사용가능
    case emaGoldenCross = "이평골든크로스"
    case emaDeathCross = "이평데드크로스"
    case disparityOverboughtEntry = "이격도과열진입"
    case disparityOverboughtExit = "이격도과열이탈"
    case disparityOversoldExit = "이격도침체이탈"
    case disparityOversoldEntry = "이격도침체진입"
    case emaPriceAboveCross = "이평가격상향돌파"
    case emaPriceBelowCross = "이평가격하향돌파"
    case cmfOverboughtEntry = "투자심리도과열진입"
    case cmfOverboughtExit = "투자심리도과열이탈"
    
    case cmfOversoldEntry = "투자심리도침체진입"
    case cmfOversoldExit = "투자심리도침체이탈"
    case aroonDeathCross = "Aroon데드크로스"
    case aroonGoldenCross = "Aroon골든크로스"
    case cciOverboughtEntry = "CCI과매도진입"
    case cciOverboughtExit = "CCI과매도이탈"
    case cciOversoldExit = "CCI과매수이탈"
    case cciOversoldEntry = "CCI과매수진입"
    case dmiGoldenCross = "DMI골든크로스"
    case dmiDeathCross = "DMI데드크로스"
    
    case eiGoldenCross = "EnergyIndex골든크로스"
    case eiDeathCross = "EnergyIndex데드크로스"
    case cciThresholdUpwardBreak = "CCI기준값상향돌파"
    case cciThresholdDownwardBreak = "CCI기준값하향돌파"
    case mesaSineGoldenCross = "MesaSine골든크로스"
    case mesaSineDeathCross = "MesaSine데드크로스"
    case psarPriceUpwardBreak = "Psar가격상향돌파"
    case psarPriceDownwardBreak = "Psar가격하향돌파"
    case rsiOverboughtEntry = "RSI과열구간진입"
    case rsiOverboughtExit = "RSI과열구간이탈"
    
    case rsiOversoldExit = "RSI침체구간이탈"
    case rsiOversoldEntry = "RSI침체구간진입"
    case rwiBullishReversal = "RWI강세전환"
    case rwiBearishReversal = "RWI약세전환"
    case stochasticFastOverboughtExit = "StochasticFast과열이탈"
    case stochasticFastOverboughtEntry = "StochasticFast과열진입"
    case stochasticFastOversoldExit = "StochasticFast침체이탈"
    case stochasticFastOversoldEntry = "StochasticFast침체진입"
    case stochasticSlowOverboughtExit = "StochasticSlow과열이탈"
    case stochasticSlowOverboughtEntry = "StochasticSlow과열진입"

    case stochasticSlowDivergenceEntry = "StochasticSlow침체진입"
    case stochasticSlowDivergenceExit = "StochasticSlow침체이탈"
    case macdThresholdCrossAbove = "MACD기준값상향돌파"
    case macdThresholdCrossBelow = "MACD기준값하향돌파"
    case momentumBullishReversal = "Momentum강세전환"
    case momentumBearishReversal = "Momentum약세전환"
    case trendScoreBullishReversal = "TrendScore강세전환"
    case trendScoreBearishReversal = "TrendScore약세전환"
    case trixThresholdCrossAbove = "Trix기준값상향돌파"
    case trixThresholdCrossBelow = "Trix기준값하향돌파"
    
    case upDownAvgGoldenCross = "UpDownAVG골든크로스"
    case upDownAvgDeathCross = "UpDownAVG데드크로스"
    case williamsRBuyEntry = "WilliamsR과매수진입"
    case williamsRBuyExit = "WilliamsR과매수이탈"
    case williamsRSellExit = "WilliamsR과매도이탈"
    case williamsRSellEntry = "WilliamsR과매도진입"
    case zigzagBearishReversal = "Zigzag하락전환"
    case zigzagBullishReversal = "Zigzag상승전환"
    case bollingerBandUpperBreakout = "BollingerBand상향돌파"
    case bollingerBandLowerBreakout = "BollingerBand하향돌파"
    
    case stochasticFastDeathCross = "StochasticFast데드크로스"
    case stochasticFastGoldenCross = "StochasticFast골든크로스"
    case disparityGoldenCross = "이격도간골든크로스"
    case disparityDeathCross = "이격도간데드크로스"
    case continuousPriceRise = "주가연속상승"
    case continuousPriceFall = "주가연속하락"
    case binaryWaveBuySignal = "BinaryWave기준값매수"
    case diPlusCrossesAboveDIMinus = "DI+가 DI-를 상향돌파"
    case diPlusCrossesBelowDIMinus = "DI+가 DI-를 하향돌파"
    case eomSignalLineCrossesAbove = "EOM기준선 상향돌파"
    
    case eomSignalLineCrossesBelow = "EOM기준선 하향돌파"
    case mfiOverboughtZoneEntry = "MFI과열권진입"
    case mfiOverboughtZoneExit = "MFI과열권이탈"
    case trixSignalGoldenCross = "TRIX-sig 골든크로스"
    case trixSignalDeathCross = "TRIX-sig 데드크로스"
    case macdSignalGoldenCross = "MACD-sig와 골든크로스"
    case macdSignalDeathCross = "MACD-sig와 데드크로스"
    case mfiOversoldZoneEntry = "MFI침체권진입"
    case mfiOversoldZoneExit = "MFI침체권이탈"
    case ichimokuCloudEntry = "일목균형구름진입"
    
    case ichimokuCloudExit = "일목균형구름이탈"
    case ichimokuCloudInside = "일목균형주가구름내부"
    case ichimokuBaseLineLeadingSpan1CrossAbove = "일목기준선선행스팬1상향돌파"
    case ichimokuBaseLineLeadingSpan1CrossBelow = "일목기준선선행스팬1하향돌파"
    case ichimokuBaseLineLeadingSpan2CrossAbove = "일목기준선선행스팬2상향돌파"
    case ichimokuBaseLineLeadingSpan2CrossBelow = "일목기준선선행스팬2하향돌파"
    case ichimokuLeadingSpan12GoldenCross = "일목선행스팬12골든크로스"
    case ichimokuLeadingSpan12DeathCross = "일목선행스팬12데드크로스"
    case ichimokuConversionLineLeadingSpan1CrossAbove = "일목전환선선행스팬1상향돌파"
    case ichimokuConversionLineLeadingSpan1CrossBelow = "일목전환선선행스팬1하향돌파"
    
    case ichimokuConversionLineLeadingSpan2CrossAbove = "일목전환선선행스팬2상향돌파"
    case ichimokuConversionLineLeadingSpan2CrossBelow = "일목전환선선행스팬2하향돌파"
    case priceRateOfChangeContinousNDays = "가격 변화율(N일연속)"
    case priceDecline = "가격급락"
    case priceAdvance = "가격급등"
    case averageVolumeOverNPeriodsMWeeks = "N일평균거래량M주이상"
    case volumeDecline = "거래량급감"
    case volumeAdvance = "거래량급증"
    case volumeHighRenewal = "거래량최고치갱신"
    case volumeLowRenewal = "거래량최저치갱신"
    
    case periodHigh = "기간내최고가"
    case periodLow = "기간내최저가"
    case noTradingStock = "무거래종목"
    case newHigh = "신고가"
    case newLow = "신저가"
    case movingAverageUpturn = "이동평균선상승전환"
    case movingAverageDownturn = "이동평균선하락전환"
    case movingAverageSupportLineNear = "이평지지선근접"
    case movingAverageResistanceLineNear = "이평저항선근접"
    case movingAverageConvergence = "이평선밀집"
    
    case movingAverageConvergenceUptrend = "이평선밀집후상승전환"
    case movingAverageConvergenceDowntrend = "이평선밀집후하락전환"
    case priceSideways = "주가횡보"
    case priceSidewaysUptrend = "주가횡보후상승전환"
    case priceSidewaysDowntrend = "주가횡보후하락전환"
    case priceMovingAverageConvergence = "주가이동평균밀집"
    case priceMovingAverageInverted = "주가이평역배열"
    case priceMovingAverageRegular = "주가이평정배열"
    case obvSignalGoldenCross = "OBV-sig와 골든크로스"
    case obvSignalDeathCross = "OBV-sig와 데드크로스"
    
    case ceilingPrice = "상한가"
    case floorPrice = "하한가"
    case stochasticSlowGoldenCross = "StochasticSlow골든크로스"
    case stochasticSlowDeathCross = "StochasticSlow데드크로스"
    case eilingPrice30Percent = "상한가(30%)"
    case loorPrice30Percent = "하한가(30%)"
}

/// 신호 - 매매신호 - 32개
enum IndiSetDetailCategorySignalsTrading: String, Codable, CaseIterable { // allCases 사용가능
    case insideDayBuy = "InsideDay매수"
    case insideDaySell = "InsideDay매도"
    case plan7percentBuy = "7%Plan매수"
    case plan7percentSell = "7%Plan매도"
    case buy180s = "180's매수"
    case sell180s = "180's매도"
    case gilligansIslandBuy = "Gilligan'sIsland매수"
    case gilligansIslandSell = "Gilligan'sIsland매도"
    case lizardsBuy = "Lizards매수"
    case lizardsSell = "Lizards매도"
    
    case Oops10PercentBuy = "10%Oops매수"
    case Oops10PercentSell = "10%Oops매도"
    case slingShotsBuy = "SlingShots매수"
    case slingShotsSell = "SlingShots매도"
    case spentMarketTradingPatternBuy = "SpentMarketTradingPattern매수"
    case spentMarketTradingPatternSell = "SpentMarketTradingPattern매도"
    case extendedLevelBoomersBuy = "ExtendedLevelBoomers매수"
    case extendedLevelBoomersSell = "ExtendedLevelBoomers매도"
    case pivotPointBuy = "PivotPoint매수"
    case pivotPointSell = "PivotPoint매도"
    
    case outsideDayBuy = "OutsideDay매수"
    case outsideDaySell = "OutsideDay매도"
    case oneTwoThreeFourBuy = "1-2-3-4's매수"
    case oneTwoThreeFourSell = "1-2-3-4's매도"
    case expansionPivotsBuy = "ExpansionPivots매수"
    case expansionPivotsSell = "ExpansionPivots매도"
    case boomersBuy = "Boomers매수"
    case boomersSell = "Boomers매도"
    case adxGapperBuy = "ADXGapper매수"
    case adxGapperSell = "ADXGapper매도"
    
    case jackInTheBoxStrategyBuy = "Jack-in-the-boxStrategy매수"
    case jackInTheBoxStrategySell = "Jack-in-the-boxStrategy매도"
}

/// 패턴 - 상승반전패턴 - 27개
enum IndiSetDetailCategoryPatternsBullishReversal: String, Codable, CaseIterable { // allCases 사용가능
    case bullishHammer = "강세비석형"
    case bullishInvertedHammer = "강세잠자리형"
    case piercingPattern = "관통형"
    case identicalLows = "동일저점형"
    case identicalThreeCrows = "동일흑삼병형"
    case bullishEngulfing = "막대샌드위치형"
    case ladderBottom = "사다리바닥형"
    case risingSunDoji = "상승기아형"
    case risingFallingThreeMethods = "상승박차형"
    case bullishCounterattack = "상승반격형"
    
    case bullishKicker = "상승샅바형"
    case bullishThreeWhiteSoldiers = "상승세십자형"
    case bullishStalledPattern = "상승십자잉태형"
    case bullishKickback = "상승잉태형"
    case bullishConfirmedKickback = "상승잉태확인형"
    case bullishEngulfingHarami = "상승장악형"
    case bullishConfirmedEngulfingHarami = "상승장악확인형"
    case bullishEscape = "상승탈출형"
    case morningStar = "샛별형"
    case bullishMorningDojiStar = "십자샛별형"

    case babySwallow = "애기제비감추기형"
    case bullishThreeLineStrike = "약세삼선반격형"
    case bullishHammerInvertedHammer = "역망치형"
    case bearishThreeBlackCrows = "적삼병"
    case morningDojiStar = "전서구형"
    case tweezerBottom = "집게바닥형"
    case rareThreeRiverBottom = "희귀삼천바닥형"
}

/// 패턴 - 상승지속패턴 - 10개
enum IndiSetDetailCategoryPatternsBullishContinuation: String, Codable, CaseIterable { // allCases 사용가능
    case bullishThreeLineStrike = "강세삼선반격형"
    case matHold = "매트형"
    case blockPattern = "블록형"
    case bullishFork = "상승갈림길형"
    case bullishGapThreeMethods = "상승갭삼법형"
    case bullishSideBySideWhiteLines = "상승나란히형"
    case bullishThreeMethods = "상승삼법형"
    case bullishTasukiGap = "상승타스키갭형"
    case bullishLongWhiteCandle = "장양봉"
    case delayedPattern = "지연형"
}

/// 패턴 - 하락반전패턴 - 24개
enum IndiSetDetailCategoryPatternsBearishReversal: String, Codable, CaseIterable { // allCases 사용가능
    case professorPattern = "교수형"
    case southernStar = "남상성형"
    case crowPattern = "까마귀형"
    case hammerPattern = "망치형"
    case stoneStar = "석별형"
    case crossStoneStar = "십자석별형"
    case weakCrowPattern = "약세까마귀형"
    case weakStonePattern = "약세비석형"
    case weakInvertedHammer = "약세잠자리형"
    case shootingStar = "유성형"
    
    case tweezerTop = "집게천장형"
    case bearishAbandonedBaby = "하락기아형"
    case bearishFallingThreeMethods = "하락박차형"
    case bearishCounterattack = "하락반격형"
    case bearishKicker = "하락샅바형"
    case bearishThreeBlackCrows = "하락세십자형"
    case bearishStalledPattern = "하락십자잉태형"
    case bearishKickback = "하락잉태형"
    case bearishConfirmedKickback = "하락잉태확인형"
    case bearishEngulfingHarami = "하락장악형"
    
    case bearishConfirmedEngulfingHarami = "하락장악확인형"
    case bearishEscape = "하락탈출형"
    case blackThreeCrows = "흑삼병"
    case blackCloudCover = "흑운형"
}

/// 패턴 - 하락지속패턴 - 9개
enum IndiSetDetailCategoryPatternsBearishContinuation: String, Codable, CaseIterable { // allCases 사용가능
    case thrustingLine = "ThrustingLine"
    case crossingLine = "걸침형"
    case longBlackCandle = "장음봉"
    case entryPattern = "진입형"
    case bearishFork = "하락갈림길형"
    case bearishGapThreeMethods = "하락갭삼법형"
    case bearishSideBySidePattern = "하락나란히형"
    case bearishThreeMethods = "하락삼법형"
    case bearishTasukiGap = "하락타스키갭형"
}

/// 패턴 - 횡보구간패턴 - 0개
/// enum IndiSetDetailCategoryPatternsSidewaysRange: String, Codable, CaseIterable {}

/// 패턴 - 박스장세패턴 - 0개
/// enum IndiSetDetailCategoryPatternsBoxTrend: String, Codable, CaseIterable {}

/// 패턴 - 추세패턴 - 46개
enum IndiSetDetailCategoryPatternsTrend: String, Codable, CaseIterable { // allCases 사용가능
    case attemptedRecoveryAfter2Declines = "2연속하락후반등시도"
    case consecutiveRises2 = "2연속상승"
    case consecutiveDeclines2 = "2연속하락"
    case attemptedRecoveryAfter3Declines = "3연속하락후반등시도"
    case consecutiveRises3 = "3연속상승"
    case consecutiveDeclines3 = "3연속하락"
    case consecutiveRises4 = "4연속상승"
    case consecutiveDeclines4 = "4연속하락"
    case mPattern = "M자형"
    case twinPeaksPattern = "쌍봉형"
    
    case vBottomPattern = "V바닥형"
    case asymmetricVBottomPattern = "비대칭V바닥형"
    case expandedVBottomPattern = "V바닥형확장"
    case vTopPattern = "V천정형"
    case expandedVTopPattern = "V천정형확장"
    case asymmetricVTopPattern = "비대칭V천정형"
    case expandedAsymmetricVBottomPattern = "비대칭V바닥형확장"
    case expandedAsymmetricVTopPattern = "비대칭V천정형확장"
    case wPattern = "W자형"
    case invertedTwinPeaksPattern = "역쌍봉형"

    case bullishAscendingTriangle = "강세이동삼각"
    case headAndShouldersPattern = "머리어깨형"
    case failedRally = "반등실패"
    case bullishFlag = "상승사각깃발"
    case bullishRectangle = "상승직사각형"
    case bullishConsolidationThenBearish = "상승횡보후하락"
    case bullishAfter2ConsecutiveDeclines = "상승후2연속하락"
    case bearishDescendingTriangle = "약세이동삼각"
    case invertedHeadAndShouldersPattern = "역머리어깨형"
    case doubleBottomPattern = "이중바닥형"
    
    case doubleTopPattern = "이중천정형"
    case sidewaysAdjustmentThen2Rises = "횡보조정후2연속상승"
    case sidewaysConsolidationThenBullish = "횡보조정후상승"
    case recoveryAfterCorrection = "조정후재상승"
    case bearishRectangle = "하락직사각형"
    case bullishConsolidationThenRise = "하락횡보후상승"
    case bullishAfter2ConsecutiveRises = "하락후2연속상승"
    case expandedTriangle = "확장삼각형"
    case sidewaysConsolidationThen2Rises = "횡보후2연속상승"
    case sidewaysConsolidationThen2Declines = "횡보후2연속하락"
    
    case sidewaysConsolidationThenRise = "횡보후상승"
    case bullishConsolidationThenRecovery = "상승횡보후재상승"
    case bearishConsolidationThenSharpDecline = "하락횡보후재하락"
    case sidewaysConsolidationThenDecline = "횡보후하락"
    case recoveryAfterSharpDecline = "조정후재하락"
    case failedBreakdown = "반락실패"
}

/// 구간 74개
enum IndiSetDetailCategoryRanges: String, Codable, CaseIterable { // allCases 사용가능
    case overbought = "이격도과열구간"
    case oversold = "이격도침체구간"
    case strongTrendBetweenMovingAverages = "이평간강세구간"
    case weakTrendBetweenMovingAverages = "이평간약세구간"
    case strongTrendBetweenPriceAndMovingAverages = "이평가격간강세구간"
    case weakTrendBetweenPriceAndMovingAverages = "이평가격간약세구간"
    case overboughtInvestorSentiment = "투자심리도기준값과열"
    case oversoldInvestorSentiment = "투자심리도기준값침체"
    case strongAroon = "Aroon강세구간"
    case weakAroon = "Aroon약세구간"
    
    case overboughtCCI = "CCI과매도구간"
    case oversoldCCI = "CCI과매수구간"
    case strongDMI = "DMI강세구간"
    case weakDMI = "DMI약세구간"
    case strongMACDLine = "MACD기준선강세구간"
    case weakMACDLine = "MACD기준선약세구간"
    case bullishMACDCrossover = "MACD크로스강세구간"
    case bearishMACDCrossover = "MACD크로스약세구간"
    case strongMomentum = "Momentum강세구간"
    case weakMomentum = "Momentum약세구간"
    
    case weakMomentumBaseline = "Momentum기준선약세구간"
    case strongMomentumBaseline = "Momentum기준선강세구간"
    case strongParabolicSAR = "PSar가격강세구간"
    case weakParabolicSAR = "PSar가격약세구간"
    case overboughtRSI = "RSI과열구간"
    case oversoldRSI = "RSI침체구간"
    case strongRSI = "RSI기준값강세구간"
    case weakRSI = "RSI기준값약세구간"
    case strongTRIX = "TRIX기준값강세구간"
    case weakTRIX = "TRIX기준값약세구간"
    
    case strongTRIXBaseline = "TRIX기준선강세구간"
    case weakTRIXBaseline = "TRIX기준선약세구간"
    case strongADXBaseline = "ADX기준선강세구간"
    case weakADXBaseline = "ADX기준선약세구간"
    case strongEnergyIndex = "EnergyIndex강세구간"
    case weakEnergyIndex = "EnergyIndex약세구간"
    case strongMesaSineWave = "MesaSineWave강세"
    case weakMesaSineWave = "MesaSineWave약세"
    case strongRWI = "RWI강세구간"
    case weakRWI = "RWI약세구간"
    
    case bullishZigZag = "ZigZag상승구간"
    case bearishZigZag = "ZigZag하락구간"
    case overboughtWilliamsR = "WilliamsR과매도영역"
    case oversoldWilliamsR = "WilliamsR과매수영역"
    case strongUpDownAVG = "UpDownAVG강세구간"
    case weakUpDownAVG = "UpDownAVG약세구간"
    case strongTrendScore = "TrendScore강세구간"
    case weakTrendScore = "TrendScore약세구간"
    case strongStochasticFast = "StochasticFast강세구간"
    case weakStochasticFast = "StochasticFast약세구간"
    
    case strongStochasticSlow = "StochasticSlow강세구간"
    case weakStochasticSlow = "StochasticSlow약세구간"
    case strongABRatio = "AB-Ratio강세구간"
    case weakABRatio = "AB-Ratio약세구간"
    case strongBinaryWave = "BinaryWave강세구간"
    case weakBinaryWave = "BinaryWave약세구간"
    case overboughtChaikinsOscillator = "Chaikin'sOscillator과열구간"
    case oversoldChaikinsOscillator = "Chaikin'sOscillator침체구간"
    case strongEOM = "EOM강세구간"
    case weakEOM = "EOM약세구간"
    
    case strongNetChangeOscillator = "NetChangeOscillator강세구간"
    case weakNetChangeOscillator = "NetChangeOscillator약세구간"
    case strongNVI = "NVI기준선강세구간"
    case weakNVI = "NVI기준선약세구간"
    case strongPVI = "PVI기준선강세구간"
    case weakPVI = "PVI기준선약세구간"
    case strongPriceROC = "PriceROC강세구간"
    case weakPriceROC = "PriceROC약세구간"
    case strongSonar = "Sonar기준선강세구간"
    case weakSonar = "Sonar기준선약세구간"
    
    case strongVR = "VR강세구간"
    case weakVR = "VR약세구간"
    case overboughtMFI = "MFI과열구간"
    case oversoldMFI = "MFI침체구간"
}


/// 채움 - 가격영역채움 - 28개
enum IndiSetDetailCategoryFillPrice: String, Codable, CaseIterable { // allCases 사용가능
    
    case bollingerBandFilled = "BollingerBand채움"
    case cftppFilledFirst = "CFTPP1차채움"
    case cftppFilledSecond = "CFTPP2차채움"
    case demaFilled = "DEMA채움"
    case envelopeFilled = "Envelope채움"
    case priceMovingAverageFilled = "가격이동평균채움"
    case priceMovingAverageBetweenFilled = "가격이동평균간채움"
    case priceChannelFilled = "PriceChannel채움"
    case priceHighLowFilled = "PriceHighLow채움"
    case projectionBandFilled = "ProjectionBand채움"
    
    case psarFilled = "PSar채움"
    case temaFilled = "TEMA채움"
    case vidyaFilled = "VIDYA채움"
    case zigzagFilled = "ZigZag채움"
    case highLowFilled = "고저채움"
    case ichimokuConversionLineFilled = "일목균형지표전환기준선채움"
    case ichimokuBaseLineFilled = "일목균형지표전환선채움"
    case ichimokuLeadingSpanAFilled = "일목균형지표기준선채움"
    case standardDeviationBandsFilled = "표준오차밴드채움"
    case movingAverageHighestLowestFilled = "이평최상최하채움"
    
    case movingAverageUpperLowerFilled = "이평상하채움"
    case maEnvelopeFilled = "MAEnvelope채움"
    case linearRegIndexSignalFilled = "LinearRegIndexSignal채움"
    case cboFilled = "CBO채움"
    case keltnerChannelsFilled = "KeltnerChannels채움"
    case pivotFilledFirst = "Pivot1차채움"
    case pivotFilledSecond = "Pivot2차채움"
    case demarkFilled = "Demark채움"
}

/// 채움 - 거래량영역채움 - 2개
enum IndiSetDetailCategoryFillVolume: String, Codable, CaseIterable { // allCases 사용가능
    case volumeMovingAverageBetweenFilled = "거래량이동평균간채움"
    case volumeMovingAverageFilled = "거래량이동평균채움"
}
/// 채움 - 분석영역채움 - 22개
enum IndiSetDetailCategoryFillAnalysis: String, Codable, CaseIterable { // allCases 사용가능
    case aroonFilled = "Aroon채움"
    case cciSignalFilled = "CCI_Signal채움"
    case elerRayFilled = "ElerRay채움"
    case macdSignalFilled = "MACD_Signal채움"
    case reverseFilled = "Reverse채움"
    case rsiFilled = "RSI채움"
    case rsiSignalFilled = "RSI_Signal채움"
    case stochasticFastFilled = "StochasticFast채움"
    case stochasticSlowFilled = "StochasticSlow채움"
    case divergenceBetweenFilled = "이격도간채움"
    
    case abRatioFilled = "AB-Ratio채움"
    case openDifferenceFilled = "OpenDifference채움"
    case relativeVigorIndexFilled = "RelativeVigorIndex채움"
    case energyIndexFilled = "EnergyIndex채움"
    case erayBullBearFilled = "ErayBullBear채움"
    case rwiFilled = "RWI채움"
    case arBrFilled = "ArBr채움"
    case mesaSineWaveFilled = "MesaSineWave채움"
    case dmiFilled = "DMI채움"
    case rankCorrelationIndexFilled = "RankCorrelationIndex채움"
    
    case upDownAverageFilled = "UpDownAverage채움"
    case pviNviFilled = "PVI_NVI채움"
}


extension IndicatorSettingViewModel {
    
}
