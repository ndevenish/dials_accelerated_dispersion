#include <boost/python.hpp>

class A {
public:
  int greet() {
    return -424242;
  }
  bool eq(const A& right) {
    return true;
  }
};

BOOST_PYTHON_MODULE(dials_accelerated_dispersion_ext) {
  using namespace boost::python;
  class_<A>("A").def("greet", &A::greet).def("__eq__", &A::eq);
}
