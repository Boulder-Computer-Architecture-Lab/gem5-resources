# PARSEC benchmark suite disk image

This directory provides the resources to build the PARSEC benchmark suite to be used with gem5. Since the original suite webpage is no longer available, this images uses cirosantili's fork with various fixes to port it to modern systems.

The disk size is ~15.6 GiB and takes approx ~16 mins to build with KVM.

## References

- The official [gem5-resources](https://github.com/gem5/gem5-resources) repo.
- cirosantili's [parsec-benchmark](https://github.com/cirosantilli/parsec-benchmark) fork.
- C. Bienia, S. Kumar, J. P. Singh and K. Li, "The PARSEC benchmark suite: Characterization and architectural implications," 2008 International Conference on Parallel Architectures and Compilation Techniques (PACT), Toronto, ON, Canada, 2008, pp. 72-81.