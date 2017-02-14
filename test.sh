#!/bin/bash

run_tests() {
  for v in $(/bin/ls -1 qemu); do
    echo
    echo "Running test for qemu-arm-static v${v}..."
    docker run --rm --name qemu-${v}-arm-test -u=$(id -u $USER) -t -v $PWD/qemu/${v}/qemu-arm-static:/usr/bin/qemu-arm-static -v  $PWD/mvn_dir:/mvn_dir -v /tmp/root_m2/repository/:/root/.m2/repository/ -w /mvn_dir  maven_qemu_test:latest mvn -B archetype:generate   -DarchetypeGroupId=org.apache.maven.archetypes   -DgroupId=com.mycompany.app   -DartifactId=my-app-${v}
  done
}

if ! docker images | grep -q maven_qemu_test; then
docker build --no-cache -t maven_qemu_test .
fi

echo "This test will use Java and Maven for ARM inside a Docker Container for ARM using qemu-arm-static at different versions"
echo "2.5 : Will work"
echo "2.6 : Will work"
echo "2.7 : Will work"
echo "2.8 : Will Fail and you will need to run 'docker kill qemu-2.8-arm-test' from another shell"
echo
run_tests
