# lineage-kernel-build

GitHub Actions build for the OnePlus Ace 3V (audi, SM7675) kernel based on
`LineageOS/android_kernel_oneplus_sm8650`.

The kernel tree already contains:

- BakaSU as the `KernelSU` submodule, integrated with the tracepoint hook
- The Droidspaces GKI kABI patch for `CONFIG_SYSVIPC`
- The Droidspaces/BakaSU configuration fragment

The workflow produces an AnyKernel3 zip containing only the kernel `Image`.
It does not build or flash `vendor_boot`, `vendor_dlkm`, `system_dlkm` or a dtb.

The kernel source contains symlinks into the `sm8650-modules` repository
(`drivers/base/kernelFwUpdate`, `include/soc/oplus`, etc.), so that repository
is checked out as a sibling of the kernel tree. The device tree repository is
not needed because only `Image` is built, not `dtbs`.

## WiFi / protected exports

Before building, the workflow removes:

```text
android/abi_gki_protected_exports_aarch64
android/abi_gki_protected_exports_x86_64
```

and deletes the `protected_exports_list` entries from `BUILD.bazel`.

Some stock Qualcomm WiFi modules export protected GKI symbols such as `qca_*`.
With `CONFIG_MODULE_SIG_PROTECT=y`, the kernel rejects those unsigned modules,
which makes WiFi fail to load. Removing the list disables only that rejection;
`CONFIG_MODVERSIONS` and symbol CRC checks are still active.

## Run

Actions -> **Build BakaSU + Droidspaces kernel (Ace 3V / audi)** -> Run workflow.

Inputs:

- `kernel_repository`: kernel repository in `owner/repo` form, defaults to this project's kernel fork
- `kernel_ref`: branch/tag/commit, defaults to `lineage-23.2`
- `kernel_modules_repository`: modules repository in `owner/repo` form, defaults to `LineageOS/android_kernel_oneplus_sm8650-modules`
- `kernel_modules_ref`: modules branch/tag/commit, defaults to `lineage-23.2`
- `bakasu_ref`: optional BakaSU ref override; empty uses the pinned submodule
- `clang_version`: AOSP clang version, defaults to `r563880c`
- `clang_branch`: AOSP prebuilt clang branch, defaults to `android16-qpr2-release`

The resulting artifact is named `AnyKernel3-BakaSU-Droidspaces-audi`.

## After flashing

Open the Droidspaces app and run:

**Settings -> Requirements -> Check Requirements**

Then verify root with the BakaSU manager.
