grid_type  ="single";
grid_width =3;
grid_height=3;
stack      =3; // now many for stacked printing



// eps = 0.01;

// Main dimensions
layer_height = .2;
cell_size = 25;
height = 6.4;

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


module multiboard_core_base(  x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right) {
    board_width  = cell_size * x_cells;
    board_height = cell_size * y_cells;

    b_points = [for(i=[0: x_cells-1])
        each [
            [i*cell_size + size_l_offset*classic_bottom,             0],
            [i*cell_size + cell_size - size_l_offset*classic_bottom, 0],
            [i*cell_size + cell_size,                 0 + size_l_offset*classic_bottom],
        ]
    ];

    r_points = [for(j=[0: y_cells-1])
        each [
            [board_width,               j*cell_size + size_l_offset*classic_right],
            [board_width,               j*cell_size + cell_size - size_l_offset*classic_right],
            [board_width+size_l_offset*classic_right, j*cell_size + cell_size],
        ]
    ];

    t_points =  [for(i=[x_cells-1:-1:0])
        each [
            [i*cell_size + cell_size,                 board_height + size_l_offset],
            [i*cell_size + cell_size - size_l_offset, board_height],
            [i*cell_size + size_l_offset,             board_height],
        ]
    ];

    l_points = [for(j=[y_cells-1:-1:0])
        each [
            [0 + size_l_offset*classic_left, j*cell_size + cell_size],
            [0,                 j*cell_size + cell_size - size_l_offset*classic_left],
            [0,                 j*cell_size + size_l_offset*classic_left],
        ]
    ];

    linear_extrude(height) {
        polygon([
            each b_points,
            each r_points,
            each t_points,
            each l_points,
        ]);
    }
}

module multiboard_side_base(  x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right) {
    board_width  = cell_size * x_cells;
    board_height = cell_size * y_cells;

    b_points = [for(i=[0: x_cells-1])
        each [
            [i*cell_size + size_l_offset*classic_bottom,             0],
            [i*cell_size + cell_size - size_l_offset*classic_bottom, 0],
            [i*cell_size + cell_size,                 0 + size_l_offset*classic_bottom],
        ]
    ];

    r_points = [for(j=[0: y_cells-1])
        each [
            [board_width,               j*cell_size + size_l_offset],
            [board_width,               j*cell_size + cell_size - size_l_offset],
            [board_width+size_l_offset, j*cell_size + cell_size],
        ]
    ];

    t_points =  [for(i=[x_cells-1:-1:0])
        each [
            [i*cell_size + cell_size,                 board_height - size_l_offset],
            [i*cell_size + cell_size - size_l_offset*classic_top, board_height],
            [i*cell_size + size_l_offset*classic_top,             board_height],
        ]
    ];
    
    corner_points=(classic_top==1) ? [] : [
      [size_l_offset,y_cells*cell_size],
      [0,y_cells*cell_size],
      [0,y_cells*cell_size-size_l_offset],
      ];                  

    l_points = [for(j=[y_cells-1:-1:0])
        each [
            [0 + size_l_offset*classic_left, j*cell_size + cell_size],
            [0,                 j*cell_size + cell_size - size_l_offset*classic_left],
            [0,                 j*cell_size + size_l_offset*classic_left],
        ]
    ];

    linear_extrude(height) {
        polygon([
            each b_points,
            each r_points,
            each t_points,
            each corner_points,
            each l_points,
        ]);
    }
}

module multiboard_corner_base(x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right) {
    board_width  = cell_size * x_cells;
    board_height = cell_size * y_cells;

    b_points = [for(i=[0: x_cells-1])
        each [
            [i*cell_size + size_l_offset*classic_bottom,             0],
            [i*cell_size + cell_size - size_l_offset*classic_bottom, 0],
            [i*cell_size + cell_size,                 0 + size_l_offset*classic_bottom],
        ]
    ];

    r_points = [for(j=[0: y_cells-1])
        each [
            [board_width,               j*cell_size + size_l_offset*classic_right],
            [board_width,               j*cell_size + cell_size - size_l_offset*classic_right],
            [board_width-size_l_offset*classic_right, j*cell_size + cell_size],
        ]
    ];

    t_points =  [for(i=[x_cells-1:-1:0])
        each [
            [i*cell_size + cell_size,                 board_height - size_l_offset*classic_top],
            [i*cell_size + cell_size - size_l_offset*classic_top, board_height],
            [i*cell_size + size_l_offset*classic_top,             board_height],
        ]
    ];

    corner1_points=(classic_top==1) ? [] : [
      [size_l_offset,y_cells*cell_size],
      [0,y_cells*cell_size],
      [0,y_cells*cell_size-size_l_offset],
      ];   
      
    corner2_points=(classic_right==1 ) ? [] : [
      [x_cells*cell_size,0],
      [x_cells*cell_size-size_l_offset,0],
      [x_cells*cell_size,size_l_offset],
      ];                  
    
    l_points = [for(j=[y_cells-1:-1:0])
        each [
            [0 + size_l_offset*classic_left, j*cell_size + cell_size],
            [0,                 j*cell_size + cell_size - size_l_offset*classic_left],
            [0,                 j*cell_size + size_l_offset*classic_left],
        ]
    ];

    linear_extrude(height) {
      union(){
        polygon([
            each b_points,
            each r_points,
            each t_points,
            each corner1_points, // top left corner
            each l_points,
        ]);
        polygon([each corner2_points]); // bottom right corner
    }
    }
}



module multiboard_core(       x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right) {
  difference() {
    multiboard_core_base(x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right);
    union(){

    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
        translate([cell_size/2+i*cell_size, cell_size/2+j*cell_size])
          multiboard_tile_hole();
      }
    }
   for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
          translate([cell_size+i*cell_size, cell_size+j*cell_size])
            multiboard_tile_hole_small();
      }
    }
    }
  }
}

module multiboard_side(       x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right) {
  difference() {
    multiboard_side_base(x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right);

    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
        translate([cell_size/2+i*cell_size, cell_size/2+j*cell_size])
          multiboard_tile_hole();
      }
    }
    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-2]) {
          translate([cell_size+i*cell_size, cell_size+j*cell_size])
            multiboard_tile_hole_small();
      }
    }
  }
}

module multiboard_corner(     x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right) {
  difference() {
    multiboard_corner_base(x_cells, y_cells,classic_top,classic_bottom,classic_left,classic_right);

    for(i=[0: x_cells-1]) {
      for(j=[0: y_cells-1]) {
        translate([cell_size/2+i*cell_size, cell_size/2+j*cell_size])
          multiboard_tile_hole();
      }
    }
    for(i=[0: x_cells-2]) {
      for(j=[0: y_cells-2]) {
          translate([cell_size+i*cell_size, cell_size+j*cell_size])
            multiboard_tile_hole_small();
      }
    }
  }
}



module multiboard_tile_hole_base() {
    rotate(22.5, [0, 0, 1]) {
        translate([0, 0, (height - hole_thick_height)/2])
            cylinder(d=hole_thick_bound_circle_d, h=hole_thick_height, $fn=8);
        cylinder(d1=hole_thin_bound_circle_d, d2=hole_thick_bound_circle_d,
            h=(height - hole_thick_height)/2, $fn=8);
        translate([0, 0, height-(height - hole_thick_height)/2])
            cylinder(d1=hole_thick_bound_circle_d, d2=hole_thin_bound_circle_d,
                h=(height - hole_thick_height)/2, $fn=8);
    }
}


module multiboard_tile_hole() {
    multiboard_tile_hole_base();
    //color("#0000F0")
    translate([0, 0, -large_thread_h2/2])
    trapz_thread(large_thread_d1, large_thread_d2,
        large_thread_h1, large_thread_h2,
        thread_len=height+large_thread_h2, pitch=large_thread_pitch, $fn=large_thread_fn);
}

module multiboard_tile_hole_small() {
    cylinder(d=hole_sm_d, h=height,$fn=small_thread_fn);
    //color("#0000F0")
    translate([0, 0, -small_thread_h2/2])
    trapz_thread(small_thread_d1, small_thread_d2,
        small_thread_h1, small_thread_h2,
        thread_len=height+small_thread_h2, pitch=small_thread_pitch, $fn=small_thread_fn);
}
function spiral_segment_points(profile_points, angle_offset, z_offset) =[ 
    for (p=profile_points)
        [
            p[0] * cos(angle_offset),
            p[0] * sin(angle_offset),
            p[1] + z_offset,
        ]
    ];

function spiral_points(profile_points, spiral_len, spiral_loop_pitch) = 

    [for (i=[0:round($fn*spiral_len/spiral_loop_pitch)])
        each spiral_segment_points(
            profile_points,
            i * 360.0/$fn,
            i * spiral_loop_pitch/$fn
        )
    ];

function limit_point_number(point, profile_points_count) = 
    point >= profile_points_count ? point - profile_points_count : point;

function spiral_segment_paths(profile_points_count, segment_number) = 
    [

        each [for(point=[0:profile_points_count-1])
            [
                segment_number*profile_points_count+limit_point_number(point+1, profile_points_count),
                segment_number*profile_points_count+limit_point_number(point+1, profile_points_count)+profile_points_count,
                segment_number*profile_points_count+limit_point_number(point, profile_points_count)+profile_points_count,
                segment_number*profile_points_count+limit_point_number(point, profile_points_count)
            ]

        ],
    ];

function spiral_paths(profile_points_count, spiral_len, spiral_loop_pitch) = 
    [for (i=[0:round($fn*spiral_len/spiral_loop_pitch)-1])

        each spiral_segment_paths(profile_points_count, i)
    ];

module trapz_thread(d1, d2, h1, h2, thread_len, pitch) {
    thread_profile = [
        [d1/2, -h1/2],
        [d1/2, h1/2],
        [d2/2, h2/2],
        [d2/2, -h2/2],
    ];
    points=spiral_points(thread_profile, thread_len, pitch);
    faces=[
        [each [3:-1:0]],
        each spiral_paths(4, thread_len, pitch),
        [each [len(points)-4:len(points)-1]],
    ];

    polyhedron(
        points=points,
        faces=faces
    );
}

// classic shapes
module classic_corner(){
    multiboard_corner(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module classic_side(){ 
 multiboard_side(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }    
module classic_side2(){ 
 translate([grid_width*cell_size,0,0])
   rotate([0,0,90])
     multiboard_side(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_height, // swap xy due to rotation
      y_cells = grid_width); 
  }    
module classic_core(){
 multiboard_core(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }

// new shapes with flat sides
module flat_single(){
    multiboard_corner(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =0, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_bottom_left(){    
  multiboard_core(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_bottom_right(){
  translate([grid_width*cell_size,0,0])
    rotate([0,0,90])
      multiboard_side(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =1,  // zero for flat, 1 for normal
      x_cells = grid_height, // swap xy due to rotation
      y_cells = grid_width);
  }
module flat_top_right(){
   multiboard_corner(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =0, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
}
module flat_right_end(){

   multiboard_corner(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =0, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
}
module flat_left_end(){
 multiboard_side(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_bottom(){
  multiboard_core(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_horizontal(){
  multiboard_side(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_left(){
  multiboard_core(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_top(){
  multiboard_side(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_right(){
  translate([grid_width*cell_size,0,0])
    rotate([0,0,90])
      multiboard_side(
      classic_top   =1, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_height, // swap xy due to rotation
      y_cells = grid_width);
  }
module flat_top_left(){
  multiboard_side(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }

module flat_top_end(){

    multiboard_corner(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=1, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =0, // zero for flat, 1 for normal
      x_cells = grid_width,
      y_cells = grid_height);
  }
module flat_vert(){
  translate([grid_width*cell_size,0,0])
    rotate([0,0,90])
    multiboard_side(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=0,// zero for flat, 1 for normal
      classic_left  =1, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_height,
      y_cells = grid_width);
  }
module flat_bottom_end(){
  translate([grid_width*cell_size,0,0])
    rotate([0,0,90])
    multiboard_side(
      classic_top   =0, // zero for flat, 1 for normal
      classic_bottom=0, // zero for flat, 1 for normal
      classic_left  =0, // zero for flat, 1 for normal
      classic_right =1, // zero for flat, 1 for normal
      x_cells = grid_height,
      y_cells = grid_width);
  }

  // wrapper to add flat sides around classic panels

  
if (grid_type == "test"      ) { // classic
    separation=5;
    x_offset=cell_size*grid_width +separation;
    y_offset=cell_size*grid_height+separation;
    color("red")translate([-x_offset*4,y_offset*2,0])flat_top_end();
    color("red")translate([-x_offset*4,y_offset*1,0])flat_vert();
    color("red")translate([-x_offset*4,y_offset*0,0])flat_bottom_end();
  
    translate([-x_offset*3,y_offset*1,0])classic_core();
    translate([-x_offset*3,y_offset*2,0])classic_side();
    translate([-x_offset*2,y_offset*2,0])classic_corner();
    translate([-x_offset*2,y_offset*1,0])classic_side2();
    
    color("orange")translate([-x_offset*1,y_offset*2,0])flat_single();
    
    color("blue")translate([-x_offset*3,y_offset*0,0])flat_left_end();
    color("blue")translate([-x_offset*2,y_offset*0,0])flat_horizontal();
    color("blue")translate([-x_offset*1,y_offset*0,0])flat_right_end();

    color("green")translate([x_offset*0,y_offset*0,0])flat_bottom_left();
    color("green")translate([x_offset*1,y_offset*0,0])flat_bottom();
    color("green")translate([x_offset*2,y_offset*0,0])flat_bottom_right();

    color("green")translate([x_offset*0,y_offset*1,0])flat_left();
    color("green")translate([x_offset*1,y_offset*1,0])classic_core();
    color("green")translate([x_offset*2,y_offset*1,0])flat_right();
 
    color("green")translate([x_offset*0,y_offset*2,0])flat_top_left();
    color("green")translate([x_offset*1,y_offset*2,0])flat_top();
    color("green")translate([x_offset*2,y_offset*2,0])flat_top_right();
} else {

  for(s=[0: stack-1]){
    translate([0,0,s*(height+layer_height)]){
      if (grid_type=="core"        ){ classic_core();      }
      if (grid_type=="side"        ){ classic_side();      }
      if (grid_type=="corner"      ){ classic_corner();    }
      if (grid_type=="single"      ){ flat_single();    }
      if (grid_type=="top left"    ){ flat_top_left();     }
      if (grid_type=="top"         ){ flat_top();          }
      if (grid_type=="top right"   ){ flat_top_right();    }
      if (grid_type=="left"        ){ flat_left();         }
      if (grid_type=="right"       ){ flat_right();        }
      if (grid_type=="bottom left" ){ flat_bottom_left();  }
      if (grid_type=="bottom"      ){ flat_bottom();       }
      if (grid_type=="bottom right"){ flat_bottom_right(); }
      if (grid_type=="right end"   ){ flat_right_end();    }
      if (grid_type=="left end"    ){ flat_left_end();     }
      if (grid_type=="horizontal"  ){ flat_horizontal();   }
      if (grid_type=="top end"     ){ flat_top_end();      }
      if (grid_type=="bottom end"  ){ flat_bottom_end();   }
      if (grid_type=="vert"        ){ flat_vert();         }
      
    }
  }
}

