#!/bin/bash

set -o pipefail

# Получаем текущую раскладку
layout=$(xkb-switch | sed 's/(.*//') || ~/.local/bin/set-layout

# Иконка клавиатуры:   (nf-fa-keyboard-o)
echo " $layout"

