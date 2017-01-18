#!/bin/bash

/opt/wildfly-10.0.0.Final/bin/standalone.sh -c standalone-full-ha.xml -b 0.0.0.0 -bmanagement 0.0.0.0
