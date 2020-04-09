from skbuild import setup


setup(
    name="dials_accelerated_dispersion",
    packages=["dials_accelerated_dispersion"],
    package_dir={'dials_accelerated_dispersion': 'src/dials_accelerated_dispersion'},
    version="0.1.0",
    zip_safe=False,
)