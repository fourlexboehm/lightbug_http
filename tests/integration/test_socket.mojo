from std.testing import TestSuite


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
