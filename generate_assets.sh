#!/bin/bash
# Generate PCB images, works with native kicad-cli or flatpak

# Detect kicad-cli: prefer native, fallback to flatpak
if command -v kicad-cli >/dev/null 2>&1; then
    KICAD_CLI="kicad-cli"
elif flatpak info org.kicad.KiCad >/dev/null 2>&1; then
    KICAD_CLI="flatpak run --command=kicad-cli org.kicad.KiCad"
else
    echo "Error: kicad-cli not found, install natively or via Flatpak"
    exit 1
fi

# Create assets folder
mkdir -p assets

# Top view
$KICAD_CLI pcb render *.kicad_pcb \
    --output assets/pcb_top.png \
    --width 640 --height 640 \
    --side top

# Bottom view
$KICAD_CLI pcb render *.kicad_pcb \
    --output assets/pcb_bottom.png \
    --width 640 --height 640 \
    --side bottom

# Isometric full 3D with components
$KICAD_CLI pcb render *.kicad_pcb \
    --output assets/pcb_iso_3d.png \
    --width 1920 --height 1920 \
    --zoom 0.65 \
    --rotate 325,0,45 \
    --perspective \
    --preset follow_pcb_editor \

# SVG export
$KICAD_CLI pcb export svg *.kicad_pcb \
    --output assets/pcb_stack.svg \
    --layers B.SilkS,B.Cu,F.SilkS,Edge.Cuts,F.Cu \
    --page-size-mode 2 \
    --theme documentation


echo "All PCB images generated in assets/"
