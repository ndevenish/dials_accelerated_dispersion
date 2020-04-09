# Accelerated Dispersion for DIALS

This should do an almost identical job to the standard DIALS `dispersion`
spotfinder, except faster. It does this via SIMD instructions generated with the
intel [ispc](https://ispc.github.io/) compiler and execution model.

**This is still highly experimental and probably incomplete.**

# Installation

Firstly, you need the [ispc](https://ispc.github.io/) compiler available on the
path. Otherwise, you should be able to `libtbx.pip install [-e]` this package
without an issue. It needs to be run within `libtbx.python` because it uses
some of the environment variables defined by the TBX dispatchers to work out
where the `scitbx` include files are. These are required because that's all
the dials spotfinding infrastructure passes through at the moment.