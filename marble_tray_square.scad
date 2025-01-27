n_balls = 16; // number of places on the tray
d_ball = 16; // diameter of each ball
separation = 2; // separation between each ball
tray_thickness = 6; // how thick the tray is overall
tray_lip = 3; // how much the tray should extend outside of all the balls

$fn = $preview ? 18 : 72;

function center(i) =
  let (row = floor(i/sqrt(n_balls)))
  let (i_in_row = i - row*sqrt(n_balls))
  (d_ball+0.5*separation)*[row, i_in_row, 0];


module balls(n) {
  for (i = [0:(n-1)]) {
    translate(center(i)) sphere(d=d_ball);
  };
};


module tray(n) {
  centers = [
    center(0),
    center(sqrt(n)-1),
    center(n-sqrt(n)),
    center(n-1)
  ];

  hull() {
    for (c = centers) {
      translate(c) minkowski() {
        cylinder(h=0.5, r=1+tray_lip+d_ball-2*tray_thickness, center=true);
        sphere(d=tray_thickness-0.5);
      }
    }
  };
};

assert(
  sqrt(n_balls) == floor(sqrt(n_balls)),
  "number of balls must be a square number"
)

difference() {
  tray(n_balls);
  translate([0,0,7*d_ball/16]) balls(n_balls);
};
if ($preview) {
  %translate([0,0,7*d_ball/16]) balls(n_balls);
}
