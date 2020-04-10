#include <type_traits>
#include <vector>

#include <boost/python.hpp>

#include <scitbx/array_family/accessors/c_grid.h>
#include <scitbx/array_family/shared.h>
#include <scitbx/array_family/tiny_types.h>

#include "dispersion.h"

namespace af = scitbx::af;

void accelerated_dispersion(const af::const_ref<float, af::c_grid<2> > &src,
                            const af::const_ref<bool, af::c_grid<2> > &mask,
                            double gain,
                            af::ref<bool, af::c_grid<2> > dst,
                            af::int2 kernel_size,
                            double nsig_b,
                            double nsig_s,
                            double threshold,
                            int min_count) {
    // Convert everything to plain C objects to pass through
    const int width = src.accessor()[0];
    const int height = src.accessor()[1];
    const float *image = &src[0];

    // Convert the mask to int for now
    int *dst_int = new int[width * height];
    std::vector<int> mask_int;
    mask_int.reserve(width * height);
    std::copy(mask.begin(), mask.end(), std::back_inserter(mask_int));

    // Now call the function
    ispc::dispersion_threshold(image,
                               &mask_int[0],
                               gain,
                               dst_int,
                               width,
                               height,
                               kernel_size[0],
                               kernel_size[1],
                               nsig_b,
                               nsig_s,
                               threshold,
                               min_count,
                               0);

    // Copy the result int vector back
    std::copy(dst_int, dst_int + width * height, dst.begin());
    delete[] dst_int;
}

BOOST_PYTHON_MODULE(dials_accelerated_dispersion_ext) {
    using namespace boost::python;
    def("accelerated_dispersion",
        accelerated_dispersion,
        args("image",
             "mask",
             "gain",
             "destination",
             "kernel_size",
             "n_sigma_b",
             "n_sigma_s",
             "threshold",
             "min_count"));
}
