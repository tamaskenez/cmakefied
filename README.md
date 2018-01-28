# CMakefied

CMake support for some 3rd-party libraries that I use.
Instead of forking a library and adding CMake support in the fork (hard to maintain updates) this repo provides CMake files to other libraries without forking them.

## Usage:

    git-clone.sh imgui|Box2D|combinations|eigen # multiple args are fine

which git-clones the package's git repo as a sibling of this cmakefied directory and
copies the CMake support files into the cloned repo.

You can call then `cmake -H<DIR> ...` for that directory.

## Libraries:

- [imgui]: is Ocornut's Dear-IMGUI, with the glfw-ogl3 support files
  added as a separate library.
- [Box2D]: is Erin Catto's 2D physics lib.
- [combinations]: Howard Hinnant's combinations/permutations header library.
- [eigen]: is the C++ template library for linear algebra. Note that Eigen
  does have native CMake-support, it's only that because of the tests it didn't build
  for me. Here we just replace the tests' CMakeLists.txt with a `return()`
  because it can't be disabled otherwise.

[imgui]: https://github.com/ocornut/imgui.git
[Box2D]: https://github.com/erincatto/Box2D.git
[combinations]: https://github.com/HowardHinnant/combinations.git
[eigen]: http://eigen.tuxfamily.org/index.php
