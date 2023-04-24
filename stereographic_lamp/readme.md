# Description

This is a lamp that projects a hexagon pattern on the ceiling (or floor), created entirely in openSCAD. The pattern is customizable within the openSCAD script, and I've included an example of projecting squares.


# Parts:

* shade (printed)
* base (printed)
* stand or hanger (printed)
* 3x M3x8 screws (non-conductive)
* 3x M3 nuts (non-conductive)
* 20mm star emitter LED
* 1 cm x 1 cm adhesive heat sink (optional)
* wiring for the LED


# Assembly

The lamp prints in two halves: the shade with the pattern, and the base. Once printed, they can be glued together. Small posts help align them when gluing them. These parts can be printed without supports. I used 50% infill, but I suspect it does not matter much.

The LED PCB, the base, and either the stand or hanger are screwed together with the M3 screws and nuts. Depending on which PCB you have, the screws may get close to the pads, so I'd suggest using a non-conductive material.

The LED can be wired up however you wish. There's a hole in the side for the wires to come in. Personally, I used a USB cable to provide 5V. I wired the LED in series with an 8 ohm, 1 watt rated resistor to limit current. This runs the LED at about 1 watt. At an ambient temperature of 25 °C, the PCB dissipating 1 W got up to around 55 °C. This is probably safe for PETG and maybe even PLA, but I stuck a tiny heat sink on the back of the PCB to be safe.
