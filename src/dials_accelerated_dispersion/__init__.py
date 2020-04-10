__all__ = ["AcceleratedDispersionSpotfinderThreshold"]

from typing import TYPE_CHECKING

from libtbx import Auto

from .dials_accelerated_dispersion_ext import accelerated_dispersion

if TYPE_CHECKING:
    from libtbx.phil import scope_extract


class AcceleratedDispersionSpotfinderThreshold:
    name = "accelerated_dispersion"

    def __init__(self, params: "scope_extract"):
        self.params = params

    def compute_threshold(self, image, mask):
        """
        Compute the threshold.

        :param image: The image to process
        :param mask: The pixel mask on the image
        :returns: A boolean mask showing foreground/background pixels
        """
        # from dials.algorithms.spot_finding.threshold import DispersionThresholdStrategy

        # self._algorithm = DispersionThresholdStrategy(
        #     kernel_size=params.spotfinder.threshold.dispersion.kernel_size,
        #     gain=params.spotfinder.threshold.dispersion.gain,
        #     mask=params.spotfinder.lookup.mask,
        #     n_sigma_b=params.spotfinder.threshold.dispersion.sigma_background,
        #     n_sigma_s=params.spotfinder.threshold.dispersion.sigma_strong,
        #     min_count=params.spotfinder.threshold.dispersion.min_local,
        #     global_threshold=params.spotfinder.threshold.dispersion.global_threshold,
        if self.params.spotfinder.threshold.dispersion.global_threshold is Auto:
            threshold = 0
        else:
            threshold = int(
                self.params.spotfinder.threshold.dispersion.global_threshold
            )

        output_data = None

        accelerated_dispersion(
            image=image,
            mask=mask,
            destination=output_data,
            gain=self.params.spotfinder.threshold.dispersion.gain,
            kernel_size=self.params.spotfinder.threshold.dispersion.kernel_size,
            n_sigma_b=self.params.spotfinder.threshold.dispersion.sigma_background,
            n_sigma_s=self.params.spotfinder.threshold.dispersion.sigma_strong,
            threshold=threshold,
            min_count=self.params.spotfinder.threshold.dispersion.min_local,
        )
        return output_data
