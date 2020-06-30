//
//  TopologyTags.swift
//  ios-hwloc
//
//  Created by vhoyet on 25/06/2020.
//  Copyright © 2020 vhoyet. All rights reserved.
//

import Foundation

struct TopologyTags: Decodable {
    let title: [String]
    let tag: [String]
    let architecture: [String]
    let uname_architecture: [String]
    let sub_architecture: [String]
    let cpu_vendor: [String]
    let cpu_family: [String]
    let cpu_model: [String]
    let nbcores: [Int]
    let nbpackages: [Int]
    let NUMA: [Int]
    let SMT: [Int]
    let chassis: [String]
    let year: [Int]
    let operating_system: [String]
    let version: [Float]
    let InfiniBand: [Int]
    let note: [String]
    let GPU: [Int]
    let CUDA: [Int]
    let OpenCL: [Int]
    let MemorySideCache: [Int]
    let HeterogeneousNUMA: [Int]
    let DAX: [Int]
    let PMEM: [Int]
}

struct Topologies: Decodable {
    let xml: [TopologyTitle]
}

struct TopologyTitle: Decodable {
    let title: String
}
