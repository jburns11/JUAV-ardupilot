#!/usr/bin/env bash
rm -rf juav-fiji-mvm
mkdir juav-fiji-mvm
cd juav-fiji-mvm
mkdir juav-jars
cd juav-jars
unzip ../../target/juav-hal-sitl-*-with-dependencies.jar
rm -rf META-INF
unzip $JUAV_SRC/lib/fivmcommon.jar
rm -rf META-INF
unzip $JUAV_SRC/lib/fivmr.jar
rm -rf META-INF
unzip $JUAV_SRC/lib/rtsj.jar
rm -rf META-INF
cd ..
mkdir build
find juav-jars -name \*.class -exec cp {} build/ \;

$FIJI_HOME/bin/fivmc \
--sys-libs "-lpthread -ldl -lm -lJuavSitlJni" \
-o JuavFiji ./build/*.class \
--gc CMR \
--payload \
--rt-library=RTSJ \
--main ub.cse.juav.copter.HalSitl

${FIJI_HOME}/bin/fivmc \
--32 \
--more-opt \
--c-opt SPEED \
--g-def-max-mem 256M \
--g-def-immortal-mem 128M \
--payload \
--rt-library=RTSJ \
--gc CMR \
-o apps \
../../../juav-payloads/target/classes/ub/cse/juav/payloads/simple/SimplePayload.class 

${FIJI_HOME}/bin/fivmc \
-o mvm \
--sys-libs "-lpthread -ldl -lm" \
--32 \
--g-def-max-mem 512M \
--g-def-immortal-mem 256M \
--link-payload apps \
--link-payload JuavFiji \
--gc CMR \
../../../juav-payloads/target/classes/ub/cse/juav/payloads/vmconfig/VMConfig.class

cp -r ../../../juav-native/juav-native-ardupilot/jni/lib/lib*Sitl* .

sudo -E ./mvm

#--sys-libs "-lpthread -ldl -lm -lJuavSitlJni" \
#--link-payload JuavFiji \
#--link-payload apps \

#cp libs/* .
#./JuavFiji fiji
#cd ..
