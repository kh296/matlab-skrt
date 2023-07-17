# Using matlab-skrt with scikit-rt

## Overview

The [matlab-skrt](https://github.com/kh296/matlab-skrt/) code can be set
up as a registration engine for
[scikit-rt](https://scikit-rt.github.io/scikit-rt/), enabling its
use for image registration and atlas-based segmentation, for 3D medical
images in [DICOM](https://www.dicomstandard.org/) and
[NIfTI](https://nifti.nimh.nih.gov/) formats.  The set up
involves defining the runtime environment so that the function
[mskrt.matlabreg()](../docs/matlabreg.md) can be invoked from a
subprocess spawned by `scikit-rt`.  As outlined below, it's possible to
use the (uncompiled) `mskrt` package, or to compile `mskrt.matlabreg` as
a [standalone application](https://uk.mathworks.com/help/compiler/standalone-applications.html).

## Example

For an example registration, using `matlab-skrt` and other registration
engines with `scikit-rt`, see: [Image registration - performance checks](https://github.com/scikit-rt/scikit-rt/blob/master/examples/notebooks/image_registration_checks.ipynb)

## Software installation and setup

For `scikit-rt` documentation, including installation instructions, see:

- [https://scikit-rt.github.io/scikit-rt/](https://scikit-rt.github.io/scikit-rt/).

Three strategies for setting up `matlab-skrt` for use from `scikit-rt` are
outlined below.

### 1. Using matlab-skrt toolbox

To use the `matlab-skrt` toolbox, do as follows:

- Download the latest version of the toolbox:
  - [https://github.com/kh296/matlab-skrt/releases/latest/download/matlab-skrt.mltbx](https://github.com/kh296/matlab-skrt/releases/latest/download/matlab-skrt.mltbx)

- Follow the MATLAB instructions: [Install Add-Ons from File](https://uk.mathworks.com/help/matlab/matlab_env/get-add-ons.html#buytlxo-3)

- From a terminal windows where you'll be running `scikit-rt` code, set up
  the environment in either of the following ways:

  - Option 1: before running `scikit-rt` code:
    - Ensure that the environment variable PATH includes the path to
      the directory containing the MATLAB executable, for example
      (bash shell):
      ```
      export PATH=/path/to/directory/containing/MATLAB/executable:$PATH
      ```
    - In the `scikit-rt` code to be run, include the lines:
      ```
      from skrt.core import Defaults
      Defaults().matlab_app = True
      Defaults().matlab_runtime = False
       ```

  - Option 2: in the `scikit-rt` code to be run, include (substituting
    actual path) the lines:
    ```
    from skrt.core import Defaults
    Defaults().matlab_app = "/path/to/directory/containing/MATLAB/executable"
    Defaults().matlab_runtime = False
    ```

### 2. Using mskrt package

To use the `mskrt` package, do as follows:

- Download and uncompress the latest version of the package source archive:
  - [https://github.com/kh296/matlab-skrt/releases/latest/download/+mskrt.zip](https://github.com/kh296/matlab-skrt/releases/latest/download/+mskrt.zip)

- From a terminal windows where you'll be running `scikit-rt` code, set up
  the environment in either of the following ways:

  - Option 1: before running `scikit-rt` code:
    - Ensure that the environment variable PATH includes the path to
      the directory containing the MATLAB executable, for example
      (bash shell):
      ```
      export PATH=/path/to/directory/containing/MATLAB/executable:$PATH
      ```
    - Ensure that the environment variable MATLABPATH includes the path to
      the directory containing the `mskrt` package, for example
      (bash shell):
      ```
      export MATLABPATH=/path/to/directory/containing/mskrt/package
      ```
    - In the `scikit-rt` code to be run, include the lines:
      ```
      from skrt.core import Defaults
      Defaults().matlab_app = True
      Defaults().matlab_runtime = False
      ```

  - Option 2: in the `scikit-rt` code to be run, include (substituting
    actual paths) the lines:
    ```
    from skrt.core import Defaults
    from skrt.registration import set_engine_dir
    Defaults().matlab_app = "/path/to/directory/containing/MATLAB/executable"
    Defaults().matlab_runtime = False
    set_engine_dir("/path/to/directory/containing/mskrt/package", engine="matlab")
    ```
    As an alternative to calling the
    [skrt.registration.set_engine_dir()](https://scikit-rt.github.io/scikit-rt/skrt.registration.html#skrt.registration.set_engine_dir)
    function, the path to the directory containing the `mskrt` package may
    also be passed as the value of the `engine_dir` parameter accepted
    by the constructor of the
    [skrt.registration.Registration](https://scikit-rt.github.io/scikit-rt/skrt.registration.html#skrt.registration.Registration)
    class.
      
### 3. Using matlabreg standalone application

To create a `matlabreg` standalone application, you need to have
the [MATLAB compiler](https://mathworks.com/help/compiler/).  You can
then do as follows:

- Download and uncompress the latest version of the `mskrt` package source
  archive:
  - [https://github.com/kh296/matlab-skrt/releases/latest/download/+mskrt.zip](https://github.com/kh296/matlab-skrt/releases/latest/download/+mskrt.zip)

- Follow the instructions linked from the **Build** section of
  the MATLAB documentation: [Standalone Applications](https://mathworks.com/help/compiler/standalone-applications.html).  Alternatively, you can use
  [GNU Make](https://www.gnu.org/software/make/) with the
  `matlabreg` [Makefile](https://github.com/kh296/matlab-skrt/blob/main/Makefile).

- Follow the MATLAB instructions: [Install and Configure MATLAB runtime](https://uk.mathworks.com/help/compiler/install-the-matlab-runtime.html)

- From a terminal windows where you'll be running `scikit-rt` code, set up
  the environment in either of the following ways:

  - Option 1: before running `scikit-rt` code:
    - Ensure that the environment variable PATH includes the path to
      the directory containing the `matlabreg` executable, for example
      (bash shell):
      ```
      export PATH=/path/to/directory/containing/matlabreg/executable:$PATH
      ```

    - Follow the MATLAB instructions:
      [Set MATLAB Runtime Path for Deployment](https://mathworks.com/help/compiler/mcr-path-settings-for-run-time-deployment.html)

    - In the `scikit-rt` code to be run, include the lines:
      ```
      from skrt.core import Defaults
      Defaults().matlab_runtime = True
      ```

  - Option 2: in the `scikit-rt` code to be run, include (substituting
    actual paths) the lines:
    ```
    from skrt.core import Defaults
    from skrt.registration import set_engine_dir
    Defaults().matlab_runtime = "/path/to/matlab/runtime/install/directory"
    set_engine_dir("/path/to/directory/containing/matlabreg/executable", engine="matlab")
     ```
    As an alternative to calling the
    [skrt.registration.set_engine_dir()](https://scikit-rt.github.io/scikit-rt/skrt.registration.html#skrt.registration.set_engine_dir)
    function, the path to the directory containing the `matlabreg` executable
    may also be passed as the value of the `engine_dir` parameter accepted
    by the constructor of the
    [skrt.registration.Registration](https://scikit-rt.github.io/scikit-rt/skrt.registration.html#skrt.registration.Registration)
    class.
