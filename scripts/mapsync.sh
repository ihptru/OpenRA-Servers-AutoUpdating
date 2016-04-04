#!/bin/bash

rsync --delete -ap rsync://resource.openra.net/maps/ $HOME/.openra/maps/
