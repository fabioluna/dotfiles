#!/bin/bash
device_name = "A0:AC:69:48:7B:37"

bluetoothctl << EOF
power on
connect A0:AC:69:48:7B:37
exit
EOF

