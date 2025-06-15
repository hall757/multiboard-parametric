grid_type ="test"; 
  // setting to "test" ignores width,height and stack

  // setting to "starter" ignores stack and height
  //   creates 4 stacked tiles of size widthxwidth to
  //   assemble 2 tiles across and 2 down

  // setting to "bigstarter" ignores stack and height
  //   creates 9 stacked tiles of size widthxwidth to
  //   assemble 3 tiles across and 3 down
  
  // "demostack" create a sample stack of various size
  //   tiles
  
  // "pyramid" create a pyramid
  
grid_width =9;
grid_height=9;
stack      =4; // now many for stacked printing

// Successful stack separation with ABS, PETG and PLA+.

// eps = 0.01;

// Main dimensions
layer_height = .2;
cell_size = 25;
height = 6.4;
stacking_height=height+layer_height;

hole_thick = 3.6; // 3.280;
hole_thick_height = 2.4;
hole_thin = 1.6;

hole_rg_spiral_d=0.776;

hole_sm_d = 6.069+0.025; // 7.5;

// Single tile outer dimensions
side_l = cell_size/(1+2*cos(45));
bound_circle_d = side_l/sin(22.5);

size_l_offset = (cell_size - side_l)*0.5;

// Single tile hole dimensions
hole_thick_size = cell_size - hole_thick;
hole_thick_side_l = (cell_size - hole_thick)/(1+2*cos(45));
hole_thick_bound_circle_d = hole_thick_side_l/sin(22.5);

hole_thin_size = cell_size - hole_thin;
hole_thin_side_l = hole_thin_size/(1+2*cos(45));
hole_thin_bound_circle_d = hole_thin_side_l/sin(22.5);

large_thread_d1 = 22.5; // hole_thin_size - 0.6;
large_thread_d2 = hole_thick_size;
large_thread_h1 = 0.5;
large_thread_h2 = 1.583;
large_thread_fn=32;
large_thread_pitch = 2.5;

small_thread_pitch = 3;
small_thread_d1 = 7.025;
small_thread_d2 = 6.069;
small_thread_h1 = 0.768;
small_thread_h2 = small_thread_pitch-0.5;
small_thread_fn=32;

c=cell_size;
o=size_l_offset;
o2=cell_size-size_l_offset;

  
ring_points=[
  [o,0],[c-o,0],[c,o], // bottom
  [c,c+o],[c,c-o],[c-o,c], // right
  [c,c-o],[c-o,c],[o,c], // top 
  [o,c],[0,c-o],[0,o]];// left
diamond_points=[
  [c,c-o], // bottom
  [c+o,c], // right
  [c,c+o], // top 
  [c-o,c]];// left
module multiboard_ring(x=0,y=0,z=0) {
  translate([cell_size*x,cell_size*y,stacking_height*z])
    render()color("white")difference(){
      linear_extrude(height){polygon(ring_points);};
      translate([cell_size/2, cell_size/2])multiboard_tile_hole();}}
module multiboard_diamond(x=0,y=0,z=0) {
  translate([cell_size*x,cell_size*y,stacking_height*z])
    render()color("white")difference(){
      linear_extrude(height){polygon(diamond_points);};
      translate([cell_size,cell_size])multiboard_tile_hole_small();}}  
module solid_sw(){render()linear_extrude(height)polygon([[0 , 0],[0,o],[o ,0]]);}
module solid_nw(){render()linear_extrude(height)polygon([[0 ,o2],[o,c],[ 0,c]]);}
module solid_se(){render()linear_extrude(height)polygon([[o2, 0],[c,0],[ c,o]]);}
module solid_ne(){render()linear_extrude(height)polygon([[c ,o2],[c,c],[o2,c]]);}
module filler(x_cells,y_cells,z_layers=1,s=0,left=false,right=false,top=false,bottom=false){
  for (z=[s+0:1:s+z_layers-1]) { 
    for(x=[0:1:x_cells-1]) {
        if (bottom) translate([x*cell_size,0,z*stacking_height]){solid_sw();solid_se();}
        if (top) translate([x*cell_size,(y_cells-1)*cell_size,z*stacking_height]){solid_nw();solid_ne();}}    
    for(y=[0:1:y_cells-1]) {
        if (left) translate([0,y*cell_size,z*stacking_height]){solid_sw();solid_nw();}
        if (right) translate([(x_cells-1)*cell_size,y*cell_size,z*stacking_height]){solid_se();solid_ne();}}}}
module multiboard_core(  x_cells=1,y_cells=1,z_layers=1,s=0,left=false,right=false,bottom=false,top=false) {
  union(){
    for(z=[0:z_layers-1]){
        for(x=[0: x_cells-1]) {
          for(y=[0: y_cells-1]) {
            multiboard_ring(x,y,z+s);
            multiboard_diamond(x,y,z+s);}}}
        filler(x_cells,y_cells,z_layers,s,left=left,bottom=bottom);}}
module multiboard_side(  x_cells=1,y_cells=1,z_layers=1,s=0,left=false,right=false,bottom=false,top=false) {
  union(){
    for(z=[0:z_layers-1]){
        for(x=[0: x_cells-1]) {
          for(y=[0: y_cells-1]) {
            multiboard_ring(x,y,z+s);
            if (y < y_cells-1) { multiboard_diamond(x,y,z+s);}}}}
        filler(x_cells,y_cells,z_layers,s,left=left,top=top,bottom=bottom);}}
module multiboard_3way(  x_cells=1,y_cells=1,z_layers=1,s=0,left=false,right=false,bottom=false,top=false) {
  union(){
    for(z=[0:z_layers-1]){
        for(x=[0: x_cells-1]) {
          for(y=[-1: y_cells-1]) {
            if (y >= 0) {multiboard_ring(x,y,z+s);}
            multiboard_diamond(x,y,z+s);}}}
        filler(x_cells,y_cells,z_layers,s,left=left,right=right,top=top);}}
module multiboard_4way(  x_cells=1,y_cells=1,z_layers=1,s=0,left=false,right=false,bottom=false,top=false) {
  union(){
    for(z=[0:z_layers-1]){
        for(x=[-1: x_cells-1]) {
          for(y=[-1: y_cells-1]) {
            if (y >= 0) if (x>=0) {multiboard_ring(x,y,z+s);}
            multiboard_diamond(x,y,z+s);}}}}}
module multiboard_corner(x_cells=1,y_cells=1,z_layers=1,s=0,left=false,right=false,bottom=false,top=false) {
  union(){
    for(z=[0:z_layers-1]){
        for(x=[0: x_cells-1]) {
          for(y=[0: y_cells-1]) {
            multiboard_ring(x,y,z+s);
            if (y < y_cells-1) {
              if (x < x_cells-1) { multiboard_diamond(x,y,z+s);}}}}}
        filler(x_cells,y_cells,z_layers,s,left,right,top,bottom);}}

module multiboard_tile_hole_base() {
    render()rotate(22.5, [0, 0, 1]) {
      union(){
        translate([0, 0, -height/2])
            cylinder(d=hole_thick_bound_circle_d, h=height*2, $fn=8);
        cylinder(d1=hole_thin_bound_circle_d, d2=hole_thick_bound_circle_d,
            h=(height - hole_thick_height)/2, $fn=8);
        translate([0,0,-.999])cylinder(d=hole_thin_bound_circle_d,
            h=1, $fn=8);
        translate([0,0,height-.001])cylinder(d=hole_thin_bound_circle_d,
            h=1, $fn=8);
        translate([0, 0, height-(height - hole_thick_height)/2])
            cylinder(d1=hole_thick_bound_circle_d, d2=hole_thin_bound_circle_d,
                h=(height - hole_thick_height)/2, $fn=8);}}}
module multiboard_tile_hole() {
    multiboard_tile_hole_base();
    translate([0, 0, -large_thread_h2/2])
    trapz_thread(large_thread_d1, large_thread_d2,
        large_thread_h1, large_thread_h2,
        thread_len=height+large_thread_h2, pitch=large_thread_pitch, $fn=large_thread_fn);}
module multiboard_tile_hole_small() {
    translate([0,0,-.5])cylinder(d=hole_sm_d, h=height+1,$fn=small_thread_fn);
    translate([0, 0, -small_thread_h2/2])
    trapz_thread(small_thread_d1, small_thread_d2,
        small_thread_h1, small_thread_h2,
        thread_len=height+small_thread_h2, pitch=small_thread_pitch, $fn=small_thread_fn);}
function spiral_segment_points(profile_points, angle_offset, z_offset) =[ 
    for (p=profile_points)[p[0] * cos(angle_offset),p[0] * sin(angle_offset),p[1] + z_offset,]];
function spiral_points(profile_points, spiral_len, spiral_loop_pitch) = 
    [for (i=[0:round($fn*spiral_len/spiral_loop_pitch)])each spiral_segment_points(profile_points,i * 360.0/$fn,i * spiral_loop_pitch/$fn)];
function limit_point_number(point, profile_points_count) = 
    point >= profile_points_count ? point - profile_points_count : point;
function spiral_segment_paths(profile_points_count, segment_number) = 
    [ each [for(point=[0:profile_points_count-1])
               [segment_number*profile_points_count+limit_point_number(point+1, profile_points_count),
                segment_number*profile_points_count+limit_point_number(point+1, profile_points_count)+profile_points_count,
                segment_number*profile_points_count+limit_point_number(point, profile_points_count)+profile_points_count,
                segment_number*profile_points_count+limit_point_number(point, profile_points_count)]],];
function spiral_paths(profile_points_count, spiral_len, spiral_loop_pitch) = 
    [for (i=[0:round($fn*spiral_len/spiral_loop_pitch)-1])each spiral_segment_paths(profile_points_count, i)];
module trapz_thread(d1, d2, h1, h2, thread_len, pitch) {
    thread_profile = [[d1/2, -h1/2],[d1/2, h1/2],[d2/2, h2/2],[d2/2, -h2/2],];
    points=spiral_points(thread_profile, thread_len, pitch);
    faces=[[each [3:-1:0]],
            each spiral_paths(4, thread_len, pitch),
           [each [len(points)-4:len(points)-1]],];
    polyhedron(points=points,faces=faces);}


if (grid_type == "bigstarter" ) {
  s=(height+layer_height);
                      multiboard_core(  grid_width,grid_width,4);
  translate([0,0,s*4])multiboard_side(  grid_width,grid_width,4);
  translate([0,0,s*8])multiboard_corner(grid_width,grid_width,1);}
  
if (grid_type == "starter" ) {
  s=(height+layer_height);
  translate([0,0,s*0])multiboard_core(grid_width,grid_width);
  translate([0,0,s*1])multiboard_side(grid_width,grid_width,2);
  translate([0,0,s*3])multiboard_corner(grid_width,grid_width);}
  
if (grid_type == "test"      ) {
    // demo of various combinations.

    // generate examples of all tiles
    separation=5; testw=2; testh=3;
    x_offset=cell_size*testw +separation;
    y_offset=cell_size*testh+separation;
    gw_x_cs=[ testw * cell_size,0,0 ];

    // vertical flat sided tiles
    color("red")translate([-x_offset*4,y_offset*2,0])multiboard_corner(testw,testh,left=true,right=true,top=true);
    color("red")translate([-x_offset*4,y_offset*1,0]){translate(gw_x_cs )rotate([  0,0,90])multiboard_side(testh,testw,top=true,bottom=true);}
    color("red")translate([-x_offset*4,y_offset*0,0]){translate(gw_x_cs )rotate([  0,0,90])multiboard_side(testh,testw,left=true,top=true,bottom=true);}
  
    // classic tiles
    color("grey")translate([-x_offset*3,y_offset*1,0])multiboard_core(  testw,testh);
    color("grey")translate([-x_offset*3,y_offset*2,0])multiboard_side(  testw,testh);
    color("grey")translate([-x_offset*2,y_offset*2,0])multiboard_corner(testw,testh);
    color("grey")translate([-x_offset*2,y_offset*1,0]){translate(gw_x_cs )rotate([  0,0,90])multiboard_side(testh,testw);}
    
    // single tile
    color("orange")translate([-x_offset*1,y_offset*1+separation,0])multiboard_corner(testw,testh*2,top=true,bottom=true,left=true,right=true);
    
    // horizontal flat sided tiles
    color("blue")translate([-x_offset*3,y_offset*0,0])multiboard_side(testw,testh,top=true,left=true,bottom=true);
    color("blue")translate([-x_offset*2,y_offset*0,0])multiboard_side(testw,testh,top=true,bottom=true);
    color("blue")translate([-x_offset*1,y_offset*0,0])multiboard_corner(testw,testh,top=true,right=true,bottom=true);

    // flat sided tiles
    color("green")translate([x_offset*0,y_offset*0,0])multiboard_core(testw,testh,bottom=true,left=true);
    color("green")translate([x_offset*1,y_offset*0,0])multiboard_core(testw,testh,bottom=true);
    color("green")translate([x_offset*2,y_offset*0,0])multiboard_corner(testw,testh,right=true,bottom=true);

    color("green")translate([x_offset*0,y_offset*1,0])multiboard_core(testw,testh,left=true);
    color("green")translate([x_offset*1,y_offset*1,0])multiboard_core(testw,testh);
    color("green")translate([x_offset*2,y_offset*1,0]){translate(gw_x_cs )rotate([  0,0,90])multiboard_side(testh,testw,bottom=true);}
 
    color("green")translate([x_offset*0,y_offset*2,0])multiboard_side(testw,testh,left=true,top=true);
    color("green")translate([x_offset*1,y_offset*2,0])multiboard_side(testw,testh,top=true);
    color("green")translate([x_offset*2,y_offset*2,0])multiboard_corner(testw,testh,top=true,right=true);
}

if (grid_type == "demostack") {
  render(){
    multiboard_core(9,9,4,0);
    multiboard_side(8,4,6,4);
    multiboard_side(8,3,2,10);
    translate([0,cell_size*5,0]){
        multiboard_side(9,4,10,4);
        multiboard_side(7,3,9,5);
        multiboard_core(3,3,1,14);

    }
  }
}

if (grid_type == "pyramid") {
    multiboard_core(9,9,1,0);
    multiboard_core(8,8,1,1);
    multiboard_core(7,7,1,2);
    multiboard_core(6,6,1,3);
    multiboard_core(5,5,1,4);
    multiboard_core(4,4,1,5);
    multiboard_core(3,3,1,6);
    multiboard_core(2,2,1,7);
    multiboard_core(1,1,1,8);
 }
