#!/bin/bash

run_tests() {
  for v in $(/bin/ls -1 qemu); do
    echo
    echo "Running test for qemu-arm-static v${v} only on first cpu..."
    timeout 2m docker run --rm --cpuset-cpus="0" --name qemu-${v}-arm-test-1 -u=$(id -u $USER) -t -v $PWD/qemu/${v}/qemu-arm-static:/usr/bin/qemu-arm-static -v  $PWD/mvn_dir:/mvn_dir -v /tmp/root_m2/repository/:/root/.m2/repository/ -w /mvn_dir  maven_qemu_test:latest mvn -B archetype:generate   -DarchetypeGroupId=org.apache.maven.archetypes   -DgroupId=com.mycompany.app   -DartifactId=my-app-${v}
    echo "Cleaning up project files before second run"
    rm -rf mvn_dir/my-app*
    echo "Running test for qemu-arm-static v${v} ..."
    timeout 2m docker run --rm --name qemu-${v}-arm-test-2 -u=$(id -u $USER) -t -v $PWD/qemu/${v}/qemu-arm-static:/usr/bin/qemu-arm-static -v  $PWD/mvn_dir:/mvn_dir -v /tmp/root_m2/repository/:/root/.m2/repository/ -w /mvn_dir  maven_qemu_test:latest mvn -B archetype:generate   -DarchetypeGroupId=org.apache.maven.archetypes   -DgroupId=com.mycompany.app   -DartifactId=my-app-${v}
  done
}

if ! test -d mvn_dir ; then
  echo "Creating Maven directory"
  mkdir mvn_dir
fi

if ! docker images | grep -q maven_qemu_test; then
docker build --no-cache -t maven_qemu_test:latest .
fi

echo "This test will use Java and Maven for ARM inside a Docker Container for ARM using qemu-arm-static at different versions."
echo "Each versions from the qemu directory is tried twice. The first try is with forcing Docker to use only one CPU, second is not limit."
echo "Most a time, 2.5, 2.6 and 2.7 will work, but 2.8 and 2.9 will fail."
echo "Each Docker run have a 2 minutes timeout and there is 2 run by QEMU version"
echo
run_tests
rm -rf mvn_dir
echo "Cleaning any left over Container"
docker rm -f $(docker ps -f name=qemu-2* -q)
