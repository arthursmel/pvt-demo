//
//  Util.swift
//  DemoPvt
//
//  Created by Mel Arthurs on 26/04/2021.
//

import Foundation

func mapToCsv(map: [[String : Any]]) -> String {
    var csv = ""

    let sortedKeys = map[0].keys.sorted()
    let columns = sortedKeys.reduce(into: "") { acc, k in
        return acc.append("\(k),")
    }
    let csvColumns = String(columns.dropLast()) + "\n"
    csv.append(csvColumns)

    let resultArr: [[(String, Any)]] = map.map() { i in
        var arr = i.reduce(into: []) { acc, kv in
            acc.append((kv.key, kv.value))
        }
        arr.sort(by: { k1, k2 in
            return k1.0 < k2.0
        })
        return arr
    }

    for r in resultArr {
        for v in r {
            csv.append("\(v.1),")
        }
        csv = String(csv.dropLast())
        csv.append("\n")
    }

    return csv
}

func unixTimestamp() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

func generatePrimes(to n: Int) -> [Int] {

    if n <= 5 {
        return [2, 3, 5].filter { $0 <= n }
    }

    var arr = Array(stride(from: 3, through: n, by: 2))

    let squareRootN = Int(Double(n).squareRoot())
    for index in 0... {
        if arr[index] > squareRootN { break }
        let num = arr.remove(at: index)
        arr = arr.filter { $0 % num != 0 }
        arr.insert(num, at: index)
    }

    arr.insert(2, at: 0)
    return arr
}


