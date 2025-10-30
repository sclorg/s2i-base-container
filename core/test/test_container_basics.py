import os

from container_ci_suite.container_lib import ContainerTestLib
from container_ci_suite.engines.podman_wrapper import PodmanCLIWrapper

from conftest import VARS, skip_if_not_euid_0


class TestS2ICoreContainer:

    def setup_method(self):
        self.app = ContainerTestLib(image_name=VARS.IMAGE_NAME, s2i_image=True)

    def teardown_method(self):
        self.app.cleanup()

    def test_docker_run_usage(self):
        """
        Test if podman run works properly
        """
        assert PodmanCLIWrapper.call_podman_command(
            cmd=f"run --rm {VARS.IMAGE_NAME} &>/dev/null",
            return_output=False
        ) == 0

    def test_cgroup_limits_memory_limit_in_bytes(self):
        skip_if_not_euid_0()
        # check memory limited (only works when running as root)
        output = PodmanCLIWrapper.podman_run_command(
            cmd=f"--memory=512M {VARS.IMAGE_NAME} /usr/bin/cgroup-limits"
        )
        assert "MEMORY_LIMIT_IN_BYTES=536870912" in output
        assert PodmanCLIWrapper.podman_run_command_and_remove(
            cid_file_name=VARS.IMAGE_NAME,
            cmd="/usr/bin/cgroup-limits"
        ), "MEMORY_LIMIT_IN_BYTES not set to 536870912."

    def test_cgroup_limits_number_of_cores(self):
        skip_if_not_euid_0()
        # check cores number (only works when running as root)
        output = PodmanCLIWrapper.podman_run_command_and_remove(
            cid_file_name=VARS.IMAGE_NAME,
            cmd="/usr/bin/cgroup-limits"
        )
        assert "NUMBER_OF_CORES=2" in output, "NUMBER_OF_CORES not set to 2."

    def test_cgroup_limits_number_of_cores_with_cpuset_cpus(self):
        skip_if_not_euid_0()
        # check cores number (only works when running as root)
        output = PodmanCLIWrapper.podman_run_command(
            cmd=f"--rm --cpuset-cpus=0 {VARS.IMAGE_NAME} /usr/bin/cgroup-limits"
        )
        assert "NUMBER_OF_CORES=1" in output, "NUMBER_OF_CORES not set to 1."

    def test_cgroup_limits_no_memory_limit(self):
        # check NO_MEMORY_LIMIT when no limit is set
        output = PodmanCLIWrapper.podman_run_command_and_remove(
            cid_file_name=VARS.IMAGE_NAME,
            cmd="/usr/bin/cgroup-limits"
        )
        assert "NO_MEMORY_LIMIT=true" in output, "NO_MEMORY_LIMIT not set to true."

    def test_cgroup_limits_memory_limit_in_bytes_max(self):
        # check NO_MEMORY_LIMIT when no limit is set
        output = PodmanCLIWrapper.podman_run_command_and_remove(
            cid_file_name=VARS.IMAGE_NAME,
            cmd="/usr/bin/cgroup-limits"
        )
        assert "MEMORY_LIMIT_IN_BYTES=" in output, "MEMORY_LIMIT_IN_BYTES not in cgroup-limits"
        limit_in_bytes = output.split("MEMORY_LIMIT_IN_BYTES=")[1].strip()
        assert int(limit_in_bytes) > 10000000000000, "MEMORY_LIMIT_IN_BYTES not greater than 10000000000000."
