#!/bin/sh
#-*-sh-*-

#
# Copyright © 2009 CNRS
# Copyright © 2009-2020 Inria.  All rights reserved.
# Copyright © 2009, 2011 Université Bordeaux
# Copyright © 2014 Cisco Systems, Inc.  All rights reserved.
# See COPYING in top-level directory.
#

HWLOC_top_srcdir="/Users/vhoyet/Desktop/hwloc/hwloc-master"
HWLOC_top_builddir="/Users/vhoyet/Desktop/hwloc/hwloc-master"
srcdir="$HWLOC_top_srcdir/utils/hwloc"
builddir="$HWLOC_top_builddir/utils/hwloc"
calc="$builddir/hwloc-calc"
xmldir="$HWLOC_top_srcdir/tests/hwloc/xml"

HWLOC_PLUGINS_PATH=${HWLOC_top_builddir}/hwloc/.libs
export HWLOC_PLUGINS_PATH

HWLOC_DEBUG_CHECK=1
export HWLOC_DEBUG_CHECK

: ${TMPDIR=/tmp}
{
  tmp=`
    (umask 077 && mktemp -d "$TMPDIR/fooXXXXXX") 2>/dev/null
  ` &&
  test -n "$tmp" && test -d "$tmp"
} || {
  tmp=$TMPDIR/foo$$-$RANDOM
  (umask 077 && mkdir "$tmp")
} || exit $?
file="$tmp/test-hwloc-calc.output"

set -e
(
  echo "# root"
  $calc --if synthetic --input "node:4 core:4 pu:4" root
  echo
  echo "# all --taskset"
  $calc --if synthetic --input "node:4 core:4 pu:4" all --taskset
  echo

  echo "# hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" 0xf
  echo
  echo "# hex combination"
  $calc --if synthetic --input "node:4 core:4 pu:4" 0xf ~0x3 0xff0 '^0xf0'
  echo
  echo "# object combination"
  $calc --if synthetic --input "node:4 core:4 pu:4" core:0 pu:15 ~pu:0 '^pu:2'
  echo

  echo "# --no-smt NUMA Node range"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt node:2-3
  echo
  echo "# --no-smt hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt 0x1fe
  echo
  echo "# --no-smt=1 hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt=1 0x1fe
  echo
  echo "# --no-smt=2 hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt=2 0x1fe
  echo
  echo "# --no-smt=3 hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt=3 0x1fe
  echo
  echo "# --no-smt=4 hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt=4 0x1fe
  echo
  echo "# --no-smt=-1 hex"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no-smt=-1 0x1fe
  echo

  echo "# even PUs"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:even
  echo
  echo "# NUMA Nodes 2+"
  $calc --if synthetic --input "node:4 core:4 pu:4" node:2-
  echo
  echo "# cores 12+"
  $calc --if synthetic --input "node:4 core:4 pu:4" core:12-
  echo
  echo "# PU wrapping range"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:62:10
  echo
  echo "# some PUs in all Cores"
  $calc --if synthetic --input "node:4 core:4 pu:4" core:all.pu:1:2
  echo
  echo "# one PU in odd Cores"
  $calc --if synthetic --input "node:4 core:4 pu:4" core:odd.pu:0
  echo
  echo "# combination of different ranges, hierarchical or not"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:6:2 core:3-4.pu:1-3 node:2.pu:14:2 node:3.core:3.pu:3
  echo

  echo "# Number of NUMA Nodes"
  $calc --if synthetic --input "node:4 core:4 pu:4" root --number-of node
  echo
  echo "# Number of Cores in a NUMA Node"
  $calc --if synthetic --input "node:4 core:4 pu:4" node:2 -N core
  echo
  echo "# Number of objects at depth 3 in a NUMA Node"
  $calc --if synthetic --input "node:4 core:4 pu:4" node:2 -N 3
  echo

  echo "# List of Machine objects"
  $calc --if synthetic --input "node:4 core:4 pu:4" root --intersect Machine
  echo
  echo "# List of NUMA Nodes in a range of Cores"
  $calc --if synthetic --input "node:4 core:4 pu:4" core:4-7 -I NUMANode
  echo
  echo "# List of NUMA Nodes in a range of Cores (again)"
  $calc --if synthetic --input "node:4 core:4 pu:4" core:10-15 -I NUMANode
  echo

  echo "# Hierarchical spec for a range of PUs"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:2-3 --hierarchical group.pu
  echo
  echo "# Hierarchical spec for a range of PUs, with different separator"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:3-6 -H group.core --sep foo
  echo
  echo "# Hierarchical spec for a range of PUs (again)"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:3-6 -H core.pu
  echo
  echo "# List of PUs from another invocation with hierarchical output"
  $calc --if synthetic --input "node:4 core:4 pu:4" -I pu `$calc --if synthetic --input "node:4 core:4 pu:4" pu:3-6 -H core.pu`
  echo
  echo "# Hierarchical spec for a range of PUs (3 levels)"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:11:4 -H group.core.pu
  echo
  echo "# List of PUs from another invocation with hierarchical output (again)"
  $calc --if synthetic --input "node:4 core:4 pu:4" -I pu `$calc --if synthetic --input "node:4 core:4 pu:4" pu:11:4 -H group.core.pu`
  echo

  echo "# --largest"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:12-37 --largest
  echo
  echo "# --largest, with different separator"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:22-47 --largest --sep "_"
  echo

  echo "# Singlified output"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:22-47 --single
  echo
  echo "# Singlified PU list"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:22-47 --single --pulist
  echo

  echo "# PU list with physical output"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:33-37 --pulist --po
  echo
  echo "# NUMA Node list of physical output and different separator"
  $calc --if synthetic --input "node:4 core:4 pu:4" pu:30-37 --nodelist --po --sep foo
  echo

  echo "# Manipulating NUMA Nodes with nodesets"
  $calc --if synthetic --input "node:4 core:4 pu:4" -n node:1-2
  echo
  echo "# Nodeset output of PUs"
  $calc --if synthetic --input "node:4 core:4 pu:4" --no pu:63
  echo
  echo "# Converting NUMA Nodes from logical to physical"
  $calc --if synthetic --input "node:4 core:4 pu:4" --ni 0x5 --nodelist --po
  echo

  echo "# Physical output of NUMA Nodes when out-of-order in the topology"
  $calc --if synthetic --input "node:4(indexes=3,2,1,0) pu:2" node:1-2 --po -I node
  echo
  echo "# Converting physical to logical PU indexes when complexly ordered in the topology"
  $calc --if synthetic --input "node:4 core:4 pu:4(indexes=node:core)" --pi pu:2-5 -I pu
  echo

  echo "# Caches with attributes"
  $calc --if synthetic --input "numa:2 l3:2 pu:1" numa:0 l3u:3
  echo
  echo "# Groups with attributes"
  $calc --if synthetic --input "group:2 numa:2 l2:2 l1d:2 pu:1" Group0:1 NUMA:0
  echo
  echo "# Caches without attributes"
  $calc --if synthetic --input "group:2 numa:2 l2:2 l1d:2 pu:1" l2:0-2 L1cache:13:3
  echo

  echo "# OS devices by name"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml os=eth6 os=eth4
  echo
  echo "# OS devices by name (again)"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml os=sdc os=sr0 ~os=sda
  echo
  echo "# OS devices by range"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml os:7-8
  echo
  echo "# PCI devices by range"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci:10-11
  echo
  echo "# PCI devices by vendors/device IDs and range wrapping around"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci'[1000:0062]':3:2
  echo
  echo "# PCI devices by vendors/device IDs and index"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci'[14e4:1639]':1
  echo
  echo "# PCI devices by vendors/device IDs and range"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci'[14e4:1639]':2-5
  echo
  echo "# PCI devices added"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci=0000:62:00.1 pci=0000:02:00.1
  echo
  echo "# PCI devices intersection"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci=0000:62:00.1 xpci=0000:02:00.0
  echo
  echo "# PCI devices intersection (again)"
  $calc --if xml --input $xmldir/96em64t-4n4d3ca2co-pci.xml pci=0000:02:00.0 xpci=0000:02:00.1
  echo
  echo "# Restrict"
  $calc -i "node:4 pu:4" --restrict 0xf0 --restrict-flags cpuless all -N pu
  $calc -i "node:4 pu:4" --restrict 0xf0 --restrict-flags cpuless all -N numa
  $calc -i "node:4 pu:4" --restrict-flags bynode,memless --restrict 0x3 all -N pu
  $calc -i "node:4 pu:4" --restrict 0xff0 --restrict-flags none all -N pu
  $calc -i "node:4 pu:4" --restrict-flags cpuless --restrict 0xff0 all -I numa --po
  echo

  echo "# Reading from stdin"
  cat << EOF | $calc --if synthetic --input "node:4 core:4 pu:4"
pu:0
core:0 core:15
node:0 node:3
0x0001 0x00002 0x000004 0x000000000008
0x0000000000000000000000000000000000000000000000000000000000000000000000000000001
0x1,0x0,0x0
root
EOF
  echo
) > "$file"
/usr/bin/diff -u -w $srcdir/test-hwloc-calc.output "$file"
rm -rf "$tmp"
