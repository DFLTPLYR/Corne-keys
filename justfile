board := "nice_nano_v2"
left_shield := "corne_left nice_oled"
right_shield := "corne_right nice_oled"
snippet := "nrf52840-nosd"

zephyr_base := `realpath zephyr`

zephyr_dir := zephyr_base + "/share/zephyr-package/cmake"

tc_path := `dirname $(dirname $(realpath $(which arm-none-eabi-gcc)))`

zmk_config := "-DZMK_CONFIG=" + justfile_directory() + "/config"

build-left:
    ZEPHYR_BASE={{zephyr_base}} ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb GNUARMEMB_TOOLCHAIN_PATH={{tc_path}} west build -b {{board}} -d build/left zmk/app -S {{snippet}} -- -DSHIELD="{{left_shield}}" {{zmk_config}} -DZephyr_DIR="{{zephyr_dir}}"
    mkdir -p firmware && cp build/left/zephyr/zmk.uf2 firmware/left.uf2

build-right:
    ZEPHYR_BASE={{zephyr_base}} ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb GNUARMEMB_TOOLCHAIN_PATH={{tc_path}} west build -b {{board}} -d build/right zmk/app -S {{snippet}} -- -DSHIELD="{{right_shield}}" {{zmk_config}} -DZephyr_DIR="{{zephyr_dir}}"
    mkdir -p firmware && cp build/right/zephyr/zmk.uf2 firmware/right.uf2

build-settings-reset:
    ZEPHYR_BASE={{zephyr_base}} ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb GNUARMEMB_TOOLCHAIN_PATH={{tc_path}} west build -b {{board}} -d build/settings_reset zmk/app -S {{snippet}} -- -DSHIELD="settings_reset" -DZephyr_DIR="{{zephyr_dir}}"
    mkdir -p firmware && cp build/settings_reset/zephyr/zmk.uf2 firmware/settings_reset.uf2

build: build-left build-right build-settings-reset

flash-left:
    west flash -d build/left

flash-right:
    west flash -d build/right

menuconfig:
    ZEPHYR_BASE={{zephyr_base}} ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb GNUARMEMB_TOOLCHAIN_PATH={{tc_path}} west build -t menuconfig -d build/left zmk/app -- -DZephyr_DIR="{{zephyr_dir}}"

init:
    west init -l config

update:
    west update
