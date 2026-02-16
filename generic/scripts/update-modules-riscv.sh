#!/bin/bash

echo "Disabling boot-efi.mount."

systemctl disable boot-efi.mount
systemctl mask boot-efi.mount
systemctl daemon-reload

echo "Done disabling boot-efi.mount."
