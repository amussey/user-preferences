#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set private.ignore_teamviewer 1
/bin/echo -n .
$cli set remap.commandL2optionL 1
/bin/echo -n .
$cli set remap.optionR2controlR 1
/bin/echo -n .
$cli set remap.controlL2commandL 1
/bin/echo -n .
$cli set remap.controlR2commandR 1
/bin/echo -n .
$cli set remap.optionL2controlL 1
/bin/echo -n .
$cli set remap.commandR2optionR 1
/bin/echo -n .
/bin/echo
