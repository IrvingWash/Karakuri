#import "Sloppy_Math";
#load "../src/math.jai";

test_deg_to_rad :: () {
    assert(values_are_close(deg_to_rad(90), 3.5708));
} @Test
