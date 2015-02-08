#!/bin/bash

PATH=$PATH:/usr/local/bin/Elm-Platform/0.13/bin
export PATH
ELM_HOME=/usr/local/bin/Elm-Platform/0.13/share
export ELM_HOME

elm $1
