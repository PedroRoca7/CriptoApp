//
//  MarketDataModel.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 24/11/25.
//

import Foundation

// Json data:
/*
 https://api.coingecko.com/api/v3/global
 
 {
   "data": {
     "active_cryptocurrencies": 19389,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1426,
     "total_market_cap": {
       "btc": 35349581.856558,
       "eth": 1062866111.75555,
       "ltc": 36118957222.7664,
       "bch": 5701214133.6305,
       "bnb": 3604819911.76951,
       "eos": 14713259114356.4,
       "xrp": 1379110553818.61,
       "xlm": 12190911601465.1,
       "link": 240270038134.433,
       "dot": 1331573607230.33,
       "yfi": 747530084.657646,
       "sol": 22504666022.3687,
       "usd": 3105971833067.39,
       "aed": 11406681556940,
       "ars": 4.42426151057619e+15,
       "aud": 4805506818600.7,
       "bdt": 380007826726775,
       "bhd": 1171010394531.23,
       "bmd": 3105971833067.39,
       "brl": 16738085314372,
       "cad": 4382007559161.96,
       "chf": 2510457641569.71,
       "clp": 2.92315433097304e+15,
       "cny": 22049604640128.7,
       "czk": 65138556204047,
       "dkk": 20125445771627.9,
       "eur": 2694781540003.09,
       "gbp": 2369555229362.61,
       "gel": 8401653808447.28,
       "hkd": 24160143560416.3,
       "huf": 1.03074468170213e+15,
       "idr": 51720332367054810,
       "ils": 10137131100032.8,
       "inr": 276771093891281,
       "jpy": 486556938505026,
       "krw": 4575604261959642,
       "kwd": 954558323456.6,
       "lkr": 956425009422301,
       "mmk": 6521609057891589,
       "mxn": 57473694821896.3,
       "myr": 12824557698735.2,
       "ngn": 4518754181056415,
       "nok": 31783593020116.7,
       "nzd": 5532322863369.46,
       "php": 182895163814060,
       "pkr": 874132850992054,
       "pln": 11415055257001.9,
       "rub": 243818754730100,
       "sar": 11649028115186.9,
       "sek": 29663872847090.5,
       "sgd": 4051740256236.4,
       "thb": 100509248518061,
       "try": 131840118189761,
       "twd": 97597393712616.3,
       "uah": 131995121714091,
       "vef": 311000959645.037,
       "vnd": 81940954678138290,
       "zar": 53705734788160,
       "xdr": 2201348218771.01,
       "xag": 60466593750.3809,
       "xau": 751210347.545678,
       "bits": 35349581856558,
       "sats": 3534958185655795
     },
     "total_volume": {
       "btc": 1933754.37314553,
       "eth": 58142752.5795243,
       "ltc": 1975842083.97145,
       "bch": 311877741.804231,
       "bnb": 197197135.091237,
       "eos": 804870317025.597,
       "xrp": 75442506655.9351,
       "xlm": 666888471768.172,
       "link": 13143669955.2391,
       "dot": 72842057838.0656,
       "yfi": 40892692.2001597,
       "sol": 1231089423.16561,
       "usd": 169908278955.969,
       "aed": 623988154465.796,
       "ars": 242023656142031,
       "aud": 262879200759.933,
       "bdt": 20787849761399.8,
       "bhd": 64058649423.7005,
       "bmd": 169908278955.969,
       "brl": 915635885201.996,
       "cad": 239712206924.287,
       "chf": 137331424815.183,
       "clp": 159907477656621,
       "cny": 1206195863136.32,
       "czk": 3563322712870.9,
       "dkk": 1100937174598.26,
       "eur": 147414631629.825,
       "gbp": 129623535740.346,
       "gel": 459601894575.896,
       "hkd": 1321650237769.69,
       "huf": 56385590186782.7,
       "idr": 2.8292956703469e+15,
       "ils": 554538994983.939,
       "inr": 15140414258485.7,
       "jpy": 26616484784355.3,
       "krw": 250302670827953,
       "kwd": 52217911371.538,
       "lkr": 52320026077282.2,
       "mmk": 356756413323848,
       "mxn": 3144026120412.38,
       "myr": 701551283809.196,
       "ngn": 247192758721881,
       "nok": 1738681443144.89,
       "nzd": 302638757485.303,
       "php": 10005049685955.4,
       "pkr": 47818337149650.6,
       "pln": 624446227185.862,
       "rub": 13337798029052.5,
       "sar": 637245417839.615,
       "sek": 1622724819638.93,
       "sgd": 221645349898.062,
       "thb": 5498231907015.16,
       "try": 7212147689327.7,
       "twd": 5338942555677.38,
       "uah": 7220626961989,
       "vef": 17012915971.8612,
       "vnd": 4.48247676851018e+15,
       "zar": 2937904610329.41,
       "xdr": 120421982985.206,
       "xag": 3307748888.47296,
       "xau": 41094016.3482907,
       "bits": 1933754373145.53,
       "sats": 193375437314553
     },
     "market_cap_percentage": {
       "btc": 56.4455998205671,
       "eth": 11.3747047625523,
       "usdt": 5.94169024882951,
       "xrp": 4.37715583200247,
       "bnb": 3.82216608291087,
       "sol": 2.48720186541165,
       "usdc": 2.41056185607481,
       "trx": 0.836356493210625,
       "steth": 0.814474466818046,
       "doge": 0.741485432817991
     },
     "market_cap_change_percentage_24h_usd": 1.42179906181346,
     "updated_at": 1764036310
   }
 }
 */

// MARK: - Welcome
struct GlobalData: Codable {
    let data: MarketDataModel
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.abbreviated()
        }
        return String()
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.abbreviated()
        }
        return String()
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.toPercentageString()
        }
        return String()
    }

}


