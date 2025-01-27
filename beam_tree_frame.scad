wall = 2.5;
lip = 5;

block_d = [101.5, 23.5, 92.5] + 0.4*[1, 1, 1];


rotate([180,0,0])
difference() {
  cube(block_d+wall*[2,2,1]);
  translate(wall*[1,1,0]+[0,0,0]) cube(block_d+[0,0,0]);
  translate((wall+lip)*[1,0,0]) cube(block_d+[-2*lip,2*wall,-lip]);
  translate((wall+lip)*[0,1,0]) cube(block_d+[2*wall,-2*lip,-lip]);
};