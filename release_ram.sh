#!/bin/bash

#release RAM used by TCMalloc
ceph tell osd.* heap release
