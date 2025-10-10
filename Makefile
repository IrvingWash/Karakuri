shmup:
	jai ./build_example.jai - shmup && ./build/shmup/DEBUG/game

snakey:
	jai ./build_example.jai - snakey && ./build/snakey/DEBUG/game

collisions:
	jai ./build_example.jai - collisions && ./build/collisions/DEBUG/game

test:
	jai ./test.jai

clean:
	rm -rf ./build ./.build
