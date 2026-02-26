length = 100;
width = 22;
height = 1.6;
slot_width = 1.0;
margin = 3.5;

module slots() {
  n = 6;
  start = margin + 0.5*slot_width;
  end = width - start;
  delta = (end - start)/(n-1);
  slot_height = 1.1*height;
  
  for (i = [0:(n-1)]) {
    translate([margin, start + i*delta, -0.5*(slot_height-height)]) union() {
      bar_start = 0;
      bar_length = length - 2*margin;
      bar_end = bar_length - bar_start;
      bar_delta = (bar_end - bar_start)/4;
      echo(bar_start, bar_end, bar_delta);
      for(j = [0:3]) {
        echo(j, bar_start + j*bar_delta);
        translate([bar_start + j*bar_delta,0,0]) union() {
          translate([0,-0.5*slot_width,0]) cube([0.25*bar_length - 1.5*slot_width, slot_width, slot_height]);
          translate([0,0,0]) cylinder(d=slot_width, h=slot_height);
          translate([0.25*bar_length - 1.5*slot_width,0,0]) cylinder(d=slot_width, h=slot_height);
        };
      };
    };
  };
}

difference() {
  cube([length, width, height]);
  slots();
}