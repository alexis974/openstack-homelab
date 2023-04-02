#!/bin/bash

set -e

cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ..

mkdir -p ./config/swift/
KOLLA_SWIFT_BASE_IMAGE="kolla/ubuntu-source-swift-base:yoga"  # Zed version not released at the time of writing
NODE=192.168.30.41

# Generate Swift object ring
docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/object.builder create 10 3 1
for i in {0..2}
do
  docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/object.builder add r1z1-${NODE}:6000/part${i} 1
done

# Generate Swift account ring
docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/account.builder create 10 3 1
for i in {0..2}
do
  docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/account.builder add r1z1-${NODE}:6001/part${i} 1
done

# Generate Swift container ring
docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/container.builder create 10 3 1
for i in {0..2}
do
  docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/container.builder add r1z1-${NODE}:6002/part${i} 1
done

#  Rebalance the ring files
for ring in object account container
do
  docker run --rm -v $PWD/config/swift/:/etc/kolla/config/swift/ $KOLLA_SWIFT_BASE_IMAGE swift-ring-builder /etc/kolla/config/swift/${ring}.builder rebalance;
done