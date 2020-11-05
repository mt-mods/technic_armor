#!/bin/sh
# simple integration test

CFG=/tmp/minetest.conf
MTDIR=/tmp/mt
WORLDDIR=${MTDIR}/worlds/world
WORLDMODDIR=${WORLDDIR}/worldmods

cat <<EOF > ${CFG}
 technic_armor.enable_technic_armor_integration_test = true
EOF

# clone dependencies
git clone --depth 1 https://github.com/minetest-mods/3d_armor.git ${WORLDMODDIR}/3d_armor

mkdir -p ${WORLDDIR}
chmod 777 ${MTDIR} -R
docker run --rm -i \
	-v ${CFG}:/etc/minetest/minetest.conf:ro \
	-v ${MTDIR}:/var/lib/minetest/.minetest \
	-v $(pwd):/var/lib/minetest/.minetest/worlds/world/worldmods/technic_armor \
	registry.gitlab.com/minetest/minetest/server:5.3.0

test -f ${WORLDDIR}/integration_test.json && exit 0 || exit 1
