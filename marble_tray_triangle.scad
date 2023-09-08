n_balls = 10;
d_ball = 16;
separation = 2;
tray_thickness = 6;
tray_lip = 3;

$fn = $preview ? 18 : 72;

function triangle(n) = n*(n-1)/2;
function inv_triangle(n) = (1+sqrt(1+8*n))/2;

function center(i) =
  let (row = ceil(inv_triangle(i+1))-2)
  let (i_in_row = i - triangle(row+1))
  0.5*(d_ball+separation)*[-row + 2*i_in_row, row*sqrt(3), 0];
  
  
module balls(n) {
  for (i = [0:(n-1)]) {
    translate(center(i)) sphere(d=d_ball);
  };
};


module tray(n) {
  centers = [
    center(0),
    center(n+1-inv_triangle(n)),
    center(n-1),
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
  inv_triangle(n_balls) == floor(inv_triangle(n_balls)),
  "number of balls must be a triangular number"
)

difference() {
  tray(n_balls);
  translate([0,0,7*d_ball/16]) balls(n_balls);
};
if ($preview) {
  %translate([0,0,7*d_ball/16]) balls(n_balls);
}